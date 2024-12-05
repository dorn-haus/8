{k, ...}:
k.namespace ./. {
  metadata.labels."goldilocks.fairwinds.com/enabled" = "true";
  metadata.labels."pod-security.kubernetes.io/enforce" = "privileged";
}
