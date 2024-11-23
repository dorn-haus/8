{lib, ...}: let
  inherit (builtins) attrValues baseNameOf filter mapAttrs readDir;
  inherit (lib.attrsets) recursiveUpdate;
  inherit (lib.strings) hasSuffix removeSuffix;
in {
  namespace = dir: overrides:
    recursiveUpdate {
      kind = "Namespace";
      apiVersion = "v1";
      metadata.name = baseNameOf dir;
    }
    overrides;

  kustomization = dir: overrides:
    recursiveUpdate {
      kind = "Kustomization";
      apiVersion = "kustomize.config.k8s.io/v1beta1";
      resources = filter (item: item != null) (attrValues (mapAttrs (
        name: type:
          if type == "directory"
          then "${name}/ks.yaml" # app subdirectory
          else if ((name != "kustomization.yaml.nix") && (hasSuffix ".yaml.nix" name))
          then removeSuffix ".nix" name # non-flux manifest
          else null
      ) (readDir dir)));
    }
    overrides;
}
