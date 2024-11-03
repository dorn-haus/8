let
  name = "spegel";
in {
  kind = "Kustomization";
  apiVersion = "kustomize.toolkit.fluxcd.io/v1";
  metadata = {
    inherit name;
    namespace = "flux-system";
  };
  spec = {
    targetNamespace = "system";
    commonMetadata.labels."app.kubernetes.io/name" = name;
    path = "./system/spegel/app";
    prune = true;
    sourceRef = import ../../flux-system/source.nix;
    wait = true;
    interval = "30m";
    retryInterval = "1m";
    timeout = "5m";
  };
}
