{...}: {self, ...}: {
  perSystem = {pkgs, ...}: let
    inherit (builtins) attrValues isFunction mapAttrs readDir toJSON;
    inherit (pkgs.lib) lists optionals sources strings isList;

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
            value = toJSON value;
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

    # Process all files in //manifests that end in .yaml.nix.
    root = sources.sourceFilesBySuffices ../../manifests [".yaml.nix"];

    # Load sources by file extension.
    srcs = lists.flatten (walk root root);
    walk = root: dir: (attrValues (mapAttrs (
      name: type:
        if type == "directory"
        then walk root "${dir}/${name}" # recursive call
        else toYAML root dir name
    ) (readDir dir)));

    # Generate YAML contents.
    toYAML = root: dir: name: let
      # File name.
      absPath = "${dir}/${name}";
      relPath = strings.removePrefix "${root}/" absPath;
      dst = strings.removeSuffix ".nix" relPath;

      # File Contents.
      expr = import absPath;
      # If the loaded expression is a function, evaluate it.
      contents =
        if isFunction expr
        then (expr {inherit self;})
        else expr;
    in {
      inherit dst;
      src = (yaml {multidoc = isList contents;}).generate dst contents;
    };

    # Create a symbolic link to a generated source file.
    # Used for generating a symlink tree containing all manifests.
    symlinkYAML = {
      dst,
      src,
    }: let
      output = "$out/${dst}";
    in ''
      mkdir --parents "$(dirname "${output}")"
      ln --symbolic "${src}" "${output}"
    '';

    # Finally combine all elements into a symlink tree.
    manifests-dir = pkgs.stdenv.mkDerivation {
      name = "manifests";
      phases = ["installPhase"];
      installPhase = strings.concatStringsSep "\n" (map symlinkYAML srcs);
    };

    # OCI tar archive containing all manifests, used as build output.
    manifests-oci = pkgs.stdenv.mkDerivation (finalAttrs: {
      pname = "manifests";
      version = "latest.tgz";

      src = manifests-dir;
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
  in {
    devenv.shells.default.env.MANIFESTS = manifests-dir;

    packages = {
      inherit manifests-oci;
      default = manifests-oci;
    };

    apps = let
      push-oci = let
        inherit (pkgs.lib) getExe getExe';
        inherit (self.lib.cluster) github;

        flux = getExe pkgs.fluxcd;
        git = getExe pkgs.git;
        ln = getExe' pkgs.coreutils "ln";
        mktemp = getExe' pkgs.coreutils "mktemp";
        rm = getExe' pkgs.coreutils "rm";

        artifactURI = with github; "oci://${registry}/${owner}/${repository}:latest";
      in {
        type = "app";
        program = pkgs.writeShellScriptBin "push-oci" ''
          TEMP_DIR="$(${mktemp} --directory)"
          ${ln} --symbolic "${manifests-oci}" "$TEMP_DIR/manifests.tgz"
          ${flux} push artifact "${artifactURI}" --path="$TEMP_DIR/manifests.tgz" --source="$(
            ${git} config --get remote.origin.url
          )" --revision="$(
            ${git} describe --dirty
          )"
          ${rm} --recursive --force "$TEMP_DIR"
        '';
      };
    in {
      inherit push-oci;
      default = push-oci;
    };
  };
}
