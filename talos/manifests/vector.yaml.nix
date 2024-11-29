{self, ...}: {
  kind = "KmsgLogConfig";
  apiVersion = "v1alpha1";
  name = "vector-logs";
  url = "udp://${self.lib.cluster.network.external.vector}:6050/";
}
