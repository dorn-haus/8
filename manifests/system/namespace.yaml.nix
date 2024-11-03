{
  kind = "Namespace";
  apiVersion = "v1";
  metadata = {
    name = "system";
    labels."pod-security.kubernetes.io/enforce" = "privileged";
  };
}
