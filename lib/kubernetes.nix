{lib, ...}: let
  inherit (builtins) attrValues baseNameOf dirOf filter mapAttrs readDir;
  inherit (lib.attrsets) recursiveUpdate;
  inherit (lib.lists) subtractLists;
  inherit (lib.strings) hasSuffix removeSuffix;

  detectNamespace = dir: baseNameOf (dirOf dir);
in {
  namespace = dir: overrides:
    recursiveUpdate {
      kind = "Namespace";
      apiVersion = "v1";
      metadata.name = baseNameOf dir;
    }
    overrides;

  kustomization = dir: overrides:
    recursiveUpdate ({
        kind = "Kustomization";
        apiVersion = "kustomize.config.k8s.io/v1beta1";
        resources =
          subtractLists [
            "kustomization.yaml" # exclude self
            "kustomizeconfig.yaml" # configuration
            "values.yaml" # helm chart values
          ] (filter (item: item != null) (attrValues (mapAttrs (
            name: type:
              if type == "directory"
              then "${name}/ks.yaml" # app subdirectory
              else if (hasSuffix ".yaml.nix" name)
              then removeSuffix ".nix" name # non-flux manifest
              else null
          ) (readDir dir))));
      }
      // ( # helm chart values generator
        if ((readDir dir)."values.yaml.nix" or null) == "regular"
        then let
          name = baseNameOf (dirOf dir);
        in {
          configMapGenerator = [
            {
              name = "${name}-values";
              files = ["./values.yaml"];
            }
          ];
          configurations = ["./kustomizeconfig.yaml"];
        }
        else {}
      ))
    overrides;

  kustomizeconfig = {
    nameReference = [
      {
        kind = "ConfigMap";
        version = "v1";
        fieldSpecs = [
          {
            path = "spec/valuesFrom/name";
            kind = "HelmRelease";
          }
        ];
      }
    ];
  };

  fluxcd.kustomization = dir: overrides: let
    name = baseNameOf dir;
    namespace = detectNamespace dir;
    hasConfig = ((readDir dir).config or null) == "directory";
    manifestPath = dir: "./${namespace}/${name}/${dir}";
    template = ksname: spec:
      recursiveUpdate {
        kind = "Kustomization";
        apiVersion = "kustomize.toolkit.fluxcd.io/v1";
        metadata = {
          name = ksname;
          namespace = "flux-system";
        };
        spec =
          recursiveUpdate {
            targetNamespace = namespace;
            # TODO: This should be the outer "name"!
            commonMetadata.labels."app.kubernetes.io/name" = name;
            prune = true;
            sourceRef = {
              kind = "OCIRepository";
              name = "flux-system";
            };
            wait = true;
            interval = "30m";
            retryInterval = "1m";
            timeout = "5m";
          }
          spec;
      }
      overrides;

    app = template name {path = manifestPath "app";};
    config = template "${name}-config" {
      path = manifestPath "config";
      dependsOn = [app.metadata];
    };
  in
    if hasConfig
    then [app config]
    else app;
}
