inputs @ {k, ...}: let
  issuer = import ../../../cert-manager/cert-manager/config/cluster-issuer.yaml.nix inputs;
  certificate = import ../../../ingress-nginx/ingress-nginx/config/certificate.yaml.nix inputs;
in {
  hostname = k.hostname ./.;

  replicas = 2;
  restrictedAdmin = true;

  ingress = {
    extraAnnotations = {
      # TLS
      "cert-manager.io/cluster-issuer" = issuer.metadata.name;
      # Homepage
      "gethomepage.dev/enabled" = "true";
      "gethomepage.dev/name" = "Rancher";
      "gethomepage.dev/description" = "Cluster management interface";
      "gethomepage.dev/group" = "Cluster Management";
      "gethomepage.dev/icon" = "rancher.png";
      "gethomepage.dev/pod-selector" = "app=rancher";
    };
    # Rancher includes a cert-manager.io/issuer annotation by default.
    # We need to disable it so that we could use the cluster-issuer instead.
    includeDefaultExtraAnnotations = false;
    tls = {
      source = "secret";
      inherit (certificate.spec) secretName;
    };
  };
}
