{k, ...}:
k.kustomization ./. {
  resources = [
    "flux-instance.yaml"
    "git-repository.yaml"
    "helm-repository.yaml"
  ];
}
