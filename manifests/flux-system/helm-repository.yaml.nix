{pkgs, ...}:
builtins.attrValues (
  builtins.mapAttrs (name: url: {
    kind = "HelmRepository";
    apiVersion = "source.toolkit.fluxcd.io/v1";
    metadata = {
      inherit name;
      namespace = "flux-system";
    };
    spec =
      {
        inherit url;
        interval = "2h";
      }
      // (
        if pkgs.lib.strings.hasPrefix "oci://" url
        then {type = "oci";}
        else {}
      );
  })
  {
    cilium = "https://helm.cilium.io";
    grafana = "https://grafana.github.io/helm-charts";
    ingress-nginx = "https://kubernetes.github.io/ingress-nginx";
    jetstack = "https://charts.jetstack.io";
    minecraft = "https://itzg.github.io/minecraft-server-charts";
    spegel = "oci://ghcr.io/spegel-org/helm-charts";
    vector = "https://helm.vector.dev";
    zfs-localpv = "https://openebs.github.io/zfs-localpv";
  }
)
