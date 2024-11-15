let
  name = "vector";
  namespace = "monitoring";
in {
  kind = "Kustomization";
  apiVersion = "kustomize.toolkit.fluxcd.io/v1";
  metadata = {
    inherit name;
    namespace = "flux-system";
  };
  spec = {
    targetNamespace = namespace;
    commonMetadata.labels."app.kubernetes.io/name" = name;
    path = "./${namespace}/${name}/app";
    prune = true;
    sourceRef = import ../../flux-system/source.nix;
    wait = true;
    interval = "30m";
    retryInterval = "1m";
    timeout = "5m";
  };
}
