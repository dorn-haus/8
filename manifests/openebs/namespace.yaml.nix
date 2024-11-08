{
  kind = "Namespace";
  apiVersion = "v1";
  metadata = {
    name = "openebs";
    labels."pod-security.kubernetes.io/enforce" = "privileged";
  };
}
