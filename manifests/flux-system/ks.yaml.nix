ctx: {
  kind = "Kustomization";
  apiVersion = "kustomize.toolkit.fluxcd.io/v1";
  metadata = {
    name = "flux-system";
    namespace = "flux-system";
  };
  spec = {
    interval = "10m";
    prune = true;
    wait = true;
    sourceRef = import ./source.nix;
  };
}
