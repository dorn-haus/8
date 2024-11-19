{
  kind = "Kustomization";
  apiVersion = "kustomize.config.k8s.io/v1beta1";
  resources = [
    "./namespace.yaml"
    "./local-path-provisioner/ks.yaml"
    "./spegel/ks.yaml"
  ];
}
