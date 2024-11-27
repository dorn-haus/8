inputs @ {pkgs, ...}:
builtins.attrValues (
  builtins.mapAttrs (name: url: {
    kind = "HelmRepository";
    apiVersion = "source.toolkit.fluxcd.io/v1";
    metadata = {
      inherit name;
      inherit ((import ./flux-instance.yaml.nix inputs).metadata) namespace;
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
    external-secrets = "https://charts.external-secrets.io";
    grafana = "https://grafana.github.io/helm-charts";
    ingress-nginx = "https://kubernetes.github.io/ingress-nginx";
    jetstack = "https://charts.jetstack.io";
    minecraft = "https://itzg.github.io/minecraft-server-charts";
    philippwaller = "https://charts.philippwaller.com";
    spegel = "oci://ghcr.io/spegel-org/helm-charts";
    vector = "https://helm.vector.dev";
    zfs-localpv = "https://openebs.github.io/zfs-localpv";
  }
)
