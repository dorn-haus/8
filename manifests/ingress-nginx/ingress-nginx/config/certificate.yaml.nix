{self, ...}: let
  inherit (self.lib.cluster) domain;

  name = "letsencrypt-staging";
in {
  kind = "Certificate";
  apiVersion = "cert-manager.io/v1";
  metadata = {inherit name;};
  spec = {
    secretName = "${name}-tls";
    issuerRef = {
      inherit name;
      kind = "ClusterIssuer";
    };
    commonName = domain;
    dnsNames = [domain];
  };
}
