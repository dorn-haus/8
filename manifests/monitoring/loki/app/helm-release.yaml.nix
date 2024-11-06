let
  name = "loki";
in {
  kind = "HelmRelease";
  apiVersion = "helm.toolkit.fluxcd.io/v2";
  metadata = {inherit name;};
  spec = {
    interval = "30m";
    chart.spec = {
      chart = name;
      version = "3.2.1";
      sourceRef = {
        name = "grafana";
        kind = "HelmRepository";
        namespace = "flux-system";
      };
      interval = "12h";
    };
    valuesFrom = [
      {
        kind = "ConfigMap";
        name = "${name}-values";
      }
    ];
  };
}
