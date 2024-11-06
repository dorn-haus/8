let
  name = "openebs";
in {
  kind = "HelmRelease";
  apiVersion = "helm.toolkit.fluxcd.io/v2";
  metadata = {inherit name;};
  spec = {
    interval = "30m";
    chart.spec = {
      chart = name;
      version = "4.1.1";
      sourceRef = {
        inherit name;
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
