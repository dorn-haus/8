let
  name = "ingress-nginx";
in {
  kind = "Kustomization";
  apiVersion = "kustomize.toolkit.fluxcd.io/v1";
  metadata = {
    inherit name;
    namespace = "flux-system";
  };
  spec = {
    targetNamespace = name;
    commonMetadata.labels."app.kubernetes.io/name" = name;
    path = "./ingress-nginx/ingress-nginx/app";
    prune = true;
    sourceRef = import ../../flux-system/source.nix;
    wait = true;
    interval = "30m";
    retryInterval = "1m";
    timeout = "5m";
  };
}
