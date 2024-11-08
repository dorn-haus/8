let
  name = "zfs-localpv";
  namespace = "openebs";
  path = "./${namespace}/${name}";

  ks = name: spec: {
    kind = "Kustomization";
    apiVersion = "kustomize.toolkit.fluxcd.io/v1";
    metadata = {
      inherit name;
      namespace = "flux-system";
    };
    spec =
      {
        targetNamespace = namespace;
        commonMetadata.labels."app.kubernetes.io/name" = name;
        prune = true;
        sourceRef = import ../../flux-system/source.nix;
        wait = true;
        interval = "30m";
        retryInterval = "1m";
        timeout = "5m";
      }
      // spec;
  };

  app = ks name {path = "${path}/app";};
  config = ks "${name}-config" {
    path = "${path}/config";
    dependsOn = [app.metadata];
  };
in [app config]
