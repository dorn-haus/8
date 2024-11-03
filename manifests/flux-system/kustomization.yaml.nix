{
  kind = "Kustomization";
  apiVersion = "kustomize.config.k8s.io/v1beta1";
  resources = [
    # FluxInstance is only used with the flux-operator.
    # "flux-instance.yaml"

    "gotk-components.yaml"
    "oci-repository.yaml"
    "helm-repository.yaml"
    "ks.yaml"
  ];
}
