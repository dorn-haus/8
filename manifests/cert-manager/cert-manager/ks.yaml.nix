let
  name = "cert-manager";
  namespace = name;
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
        prune = false; # should never be deleted
        sourceRef = import ../../flux-system/source.nix;
        wait = true;
        interval = "30m";
        retryInterval = "1m";
        timeout = "5m";
      }
      // spec;
  };

  app = ks name {path = "${path}/app";};
  issuers = ks "${name}-issuers" {
    path = "${path}/issuers";
    dependsOn = [app.metadata];
  };
in [app issuers]
