{v, ...}: let
  name = "cert-manager";
  crds = "CreateReplace";
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
        name = "jetstack";
        kind = "HelmRepository";
        namespace = "flux-system";
      };
      interval = "12h";
    };
    install = {
      inherit crds;
      remediation.retries = 2;
    };
    upgrade = {
      inherit crds;
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
