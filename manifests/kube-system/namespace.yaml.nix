{k, ...}:
k.namespace ./. {
  metadata.labels = {
    "goldilocks.fairwinds.com/enabled" = "true";
    "kustomize.toolkit.fluxcd.io/prune" = "disabled";
  };
}
