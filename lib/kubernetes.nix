{lib, ...}: let
  inherit (builtins) baseNameOf;
in {
  namespace = dir: overrides: let
    defaults = {
      kind = "Namespace";
      apiVersion = "v1";
      metadata.name = baseNameOf dir;
    };
  in
    lib.attrsets.recursiveUpdate defaults overrides;
}
