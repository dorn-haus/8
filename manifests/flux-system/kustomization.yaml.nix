{
  kind = "Kustomization";
  apiVersion = "kustomize.config.k8s.io/v1beta1";
  resources = [
    "flux-instance.yaml"
    "gotk-components.yaml"
    "helm-repository.yaml"
  ];
}
