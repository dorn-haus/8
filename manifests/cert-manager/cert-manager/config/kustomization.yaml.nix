{
  kind = "Kustomization";
  apiVersion = "kustomize.config.k8s.io/v1beta1";
  resources = [
    "./cluster-issuer.yaml"
  ];
}
