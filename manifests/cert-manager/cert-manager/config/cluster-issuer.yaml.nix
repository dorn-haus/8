{self, ...}: let
  inherit (self.lib) cluster;

  prod = true;
  suffix =
    if prod
    then ""
    else "-staging";

  name = "letsencrypt${suffix}";
  server = "https://acme${suffix}-v02.api.letsencrypt.org/directory";
in {
  kind = "ClusterIssuer";
  apiVersion = "cert-manager.io/v1";
  metadata = {inherit name;};
  spec.acme = {
    inherit server;

    email = with cluster; "${name}@${domain}";
    preferredChain = "";
    privateKeySecretRef = {inherit name;};
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
