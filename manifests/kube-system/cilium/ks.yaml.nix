{k, ...}:
k.fluxcd.kustomization ./. {
  spec.prune = false; # should never be deleted
}
