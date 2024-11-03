let
  name = "spegel";
in {
  kind = "HelmRelease";
  apiVersion = "helm.toolkit.fluxcd.io/v2";
  metadata = {inherit name;};
  spec = {
    interval = "30m";
    chart.spec = {
      chart = name;
      version = "v0.0.27";
      sourceRef = {
        inherit name;
        kind = "HelmRepository";
        namespace = "flux-system";
      };
      interval = "12h";
    };
    install.remediation.retries = 3;
    upgrade = {
      cleanupOnFail = true;
      remediation.retries = 3;
    };
    valuesFrom = [
      {
        kind = "ConfigMap";
        name = "${name}-values";
      }
    ];
  };
}
