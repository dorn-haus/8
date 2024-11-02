{
  kind = "Namespace";
  apiVersion = "v1";
  metadata = {
    name = "kube-system";
    labels."kustomize.toolkit.fluxcd.io/prune" = "disabled";
  };
}
