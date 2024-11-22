{v, ...}: let
  name = "zfs-localpv";
in {
  kind = "HelmRelease";
  apiVersion = "helm.toolkit.fluxcd.io/v2";
  metadata = {inherit name;};
  spec = {
    interval = "30m";
    chart.spec = {
      chart = name;
      version = v.${name};
      sourceRef = {
        inherit name;
        kind = "HelmRepository";
        namespace = "flux-system";
      };
      interval = "12h";
    };
    install.remediation.retries = 2;
    upgrade = {
      cleanupOnFail = true;
      remediation.retries = 2;
    };
    valuesFrom = [
      {
        kind = "ConfigMap";
        name = "${name}-values";
      }
    ];
  };
}
