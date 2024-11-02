builtins.attrValues (
  builtins.mapAttrs (name: url: {
    apiVersion = "source.toolkit.fluxcd.io/v1";
    kind = "HelmRepository";
    metadata = {
      inherit name;
      namespace = "flux-system";
    };
    spec = {
      inherit url;
      interval = "24h";
    };
  })
  {
    cilium = "https://helm.cilium.io";
    ingress-nginx = "https://kubernetes.github.io/ingress-nginx";
  }
)
