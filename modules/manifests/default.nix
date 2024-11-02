{...}: {self, ...}: {
  perSystem = {pkgs, ...}: let
    inherit (builtins) isFunction;
    inherit (pkgs.lib) fileset lists optionals;

    # https://github.com/NixOS/nixpkgs/pull/353081
    # Include a fork of the YAML formatter until multidoc support is upstreamed:
    yaml = {multidoc ? false}: {
      generate = name: value:
        pkgs.callPackage ({
          runCommand,
          remarshal,
          jq,
        }:
          runCommand name {
            nativeBuildInputs = [remarshal] ++ optionals multidoc [jq];
            value = builtins.toJSON value;
            passAsFile = ["value"];
            preferLocalBuild = true;
          } (
            if multidoc
            then ''
              jq -c '.[]' < "$valuePath" | while IFS= read -r line; do
                echo "---"
                echo "$line" | json2yaml
              done > "$out"
            ''
            else ''
              json2yaml "$valuePath" "$out"
            ''
          )) {};

      type = let
        valueType = with builtins;
          nullOr (oneOf [
            bool
            int
            float
            str
            path
            (attrsOf valueType)
            (listOf valueType)
          ])
          // {
            description = "YAML value";
          };
      in
        valueType;
    };

    # Load sources by file extension.
    sources = fileset.fileFilter (file: file.type == "regular" && file.hasExt "yaml.nix") ../../manifests;
    # If the loaded expression is a function, evaluate it.
    # If an expression contains a list, flatten it as we don't expect top-level arrays in source files.
    exprs = lists.flatten (map (src: let
      expr = import src;
    in
      if isFunction expr
      then (expr {inherit self;})
      else expr)
    (fileset.toList sources));

    # Finally combine each element into a single generated source file.
    manifests-yaml = (yaml {multidoc = true;}).generate "manifests.yaml" exprs;
  in {
    devenv.shells.default.env.MANIFESTS = manifests-yaml;

    packages.default = pkgs.stdenv.mkDerivation (finalAttrs: {
      pname = "manifests";
      version = "latest.tgz";

      src = manifests-yaml;
      phases = ["installPhase"];
      nativeBuildInputs = with pkgs; [fluxcd];
      installPhase = ''
        flux build artifact --path="$src" --output="$out"
      '';

      meta = let
        inherit (pkgs) lib;
      in {
        description = "Kubernetes Manifests";
        homepage = with self.lib.cluster.github; "https://github.com/${owner}/${repository}";
        license = with lib.licenses; [asl20 mit];
        maintainers = with lib.maintainers; [attila];
      };
    });

    apps = let
      oci-push = let
        inherit (pkgs.lib) getExe getExe';
        inherit (self.lib.cluster) github;

        flux = getExe pkgs.fluxcd;
        git = getExe pkgs.git;
        ln = getExe' pkgs.coreutils "ln";
        mktemp = getExe' pkgs.coreutils "mktemp";
        rm = getExe' pkgs.coreutils "rm";

        artifact-url = with github; "oci://${registry}/${owner}/${repository}:latest";
      in {
        type = "app";
        program = pkgs.writeShellScriptBin "oci-push" ''
          TEMP_DIR="$(${mktemp} --directory)"
          ${ln} --symbolic "${manifests-yaml}" "$TEMP_DIR/manifests.tgz"
          ${flux} push artifact "${artifact-url}" --path="$TEMP_DIR/manifests.tgz" --source="$(
            ${git} config --get remote.origin.url
          )" --revision="$(
            ${git} describe --dirty
          )"
          ${rm} --recursive --force "$TEMP_DIR"
        '';
      };
    in {
      inherit oci-push;
      default = oci-push;
    };
  };
}
