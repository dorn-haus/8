{
  kind = "ClusterSecretStore";
  apiVersion = "external-secrets.io/v1beta1";
  metadata.name = "gcp-secrets";
  spec.provider.gcpsm = {
    projectID = "dornhaus";
    auth.secretRef.secretAccessKeySecretRef = {
      name = "gcp-secrets-service-account";
      namespace = "kube-system";
      key = "key";
    };
  };
}
