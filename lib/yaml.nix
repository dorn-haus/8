inputs @ {lib, ...}: let
  inherit (builtins) isFunction toJSON;
  inherit (lib) optionals strings generators isList;
  inherit (strings) removeSuffix;

  # https://github.com/NixOS/nixpkgs/pull/353081
  # Include a fork of the YAML formatter until multidoc support is upstreamed.
  yamlGenerate = {
    name,
    value,
    pkgs,
    multidoc,
  }:
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
in {
  format = generators.toYAML {};
  write = src: ctx @ {pkgs, ...}: let
    expr = import src;
    # If the loaded expression is a function, evaluate it.
    value =
      if isFunction expr
      then (expr (inputs // ctx))
      else expr;
    defaults = {
      inherit pkgs value;
      name = "${removeSuffix ".yaml.nix" (baseNameOf src)}.yaml";
      multidoc = isList value;
    };
    params = defaults // ctx;
  in
    yamlGenerate {inherit (params) name value pkgs multidoc;};
}
