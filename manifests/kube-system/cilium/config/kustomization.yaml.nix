{
  kind = "Kustomization";
  apiVersion = "kustomize.config.k8s.io/v1beta1";
  resources = [
    "./l2-announcement-policy.yaml"
    "./load-balancer-ip-pool.yaml"
  ];
}
