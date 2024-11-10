{self, ...}: let
  inherit (self.lib) cluster;

  name = "letsencrypt-staging";
in {
  kind = "ClusterIssuer";
  apiVersion = "cert-manager.io/v1";
  metadata = {inherit name;};
  spec.acme = {
    email = with cluster; "${name}@${domain}";
    preferredChain = "";
    privateKeySecretRef = {inherit name;};
    server = "https://acme-staging-v02.api.letsencrypt.org/directory";
    solvers = [
      {
        dns01.cloudflare.apiTokenSecretRef = {
          name = "cloudflare-api-token";
          key = "api-token";
        };
        selector.dnsZones = [cluster.domain];
      }
    ];
  };
}
