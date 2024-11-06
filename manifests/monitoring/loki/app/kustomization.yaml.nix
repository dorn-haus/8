{
  kind = "Kustomization";
  apiVersion = "kustomize.config.k8s.io/v1beta1";
  resources = ["./helm-release.yaml"];
  configMapGenerator = [
    {
      name = "loki-values";
      files = ["./values.yaml"];
    }
  ];
  configurations = ["./kustomizeconfig.yaml"];
}
