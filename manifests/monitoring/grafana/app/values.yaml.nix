inputs @ {self, ...}: let
  inherit (self.lib.cluster) domain;

  path = "/grafana";
  hosts = [domain];

  issuer = import ../../../cert-manager/cert-manager/config/cluster-issuer.yaml.nix inputs;
  certificate = import ../../../ingress-nginx/ingress-nginx/config/certificate.yaml.nix inputs;
in {
  # Expose Grafana via an ingress path on the default hostname.
  ingress = {
    inherit hosts path;

    enabled = true;

    ingressClassName = "nginx";
    annotations."cert-manager.io/cluster-issuer" = issuer.metadata.name;
    tls = [
      {
        inherit hosts;
        inherit (certificate.spec) secretName;
      }
    ];
  };

  # Allow spinning up a second replica. The default number of replicas is 1.
  autoscaling = {
    enabled = true;
    maxReplicas = 2;
  };
  podDisruptionBudget.minAvailable = 1;

  # Grafana's primary configuration.
  "grafana.ini".server = {
    # Required for serving Grafana under a subpath.
    root_url = "https://${domain}${path}";
    serve_from_sub_path = true;
    enforce_domain = true;

    # TODO: SSL passthrough:
    # protocol = "https"
    # cert_key = "/etc/grafana/grafana.key"
    # cert_file = "/etc/grafana/grafana.crt"
  };

  datasources."datasources.yaml" = {
    apiVersion = 1;
    datasources = [
      {
        name = "Loki";
        type = "loki";
        url = "http://loki:3100";
      }
    ];
    prune = true;
  };
}
