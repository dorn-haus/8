{
  v,
  self,
  ...
}: let
  inherit (self.lib) cluster;
  name = "${baseNameOf (dirOf ./.)}-values";
in {
  kind = "ExternalSecret";
  apiVersion = "external-secrets.io/v1beta1";
  metadata = {inherit name;};
  spec = {
    refreshInterval = "2h";
    secretStoreRef = {
      kind = "ClusterSecretStore";
      name = "gcp-secrets";
    };
    target = {
      inherit name;
      template = {
        engineVersion = "v2";
        data = {
          "values.yaml" = self.lib.yaml.format {
            image.tag = "v${v.inadyn-app}";
            inadynConfig = ''
              period = 480

              provider cloudflare.com { # main
                  hostname = ${cluster.domain}
                  username = ${cluster.domain}
                  password = {{ .cloudflare_api_token }}
                  ttl = 1 # automatic
              }

              provider duckdns.org { # backup
                  hostname = dornhaus.duckdns.org
                  username = {{ .duckdns_token }}
              }
            '';
          };
        };
      };
    };
    dataFrom = [{extract.key = "external-secrets";}];
  };
}
