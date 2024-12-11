inputs @ {self, ...}: let
  inherit (self.lib.cluster) domain;

  issuer = import ../../../cert-manager/cert-manager/config/cluster-issuer.yaml.nix inputs;
  certificate = import ../../../ingress-nginx/ingress-nginx/config/certificate.yaml.nix inputs;
in {
  config = {
    kubernetes.mode = "cluster";
    settings = {};
    widgets = [
      {
        kubernetes = {
          cluster = {
            show = true;
            cpu = true;
            memory = true;
            showLabel = true;
            label = "cluster";
          };
          nodes = {
            show = true;
            cpu = true;
            memory = true;
            showLabel = true;
          };
        };
      }
    ];
  };

  serviceAccount = {
    create = true;
    name = "homepage";
  };

  enableRbac = true;

  ingress.main = {
    enabled = true;
    hosts = [{host = domain;}];
    annotations."cert-manager.io/cluster-issuer" = issuer.metadata.name;
    tls = [
      {
        hosts = [domain];
        inherit (certificate.spec) secretName;
      }
    ];
  };
}
