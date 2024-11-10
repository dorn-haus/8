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
    ingress-nginx = "https://kubernetes.github.io/ingress-nginx";
    jetstack = "https://charts.jetstack.io";
    spegel = "oci://ghcr.io/spegel-org/helm-charts";
    zfs-localpv = "https://openebs.github.io/zfs-localpv";
  }
)
