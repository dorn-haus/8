{k, ...}:
k.fluxcd.helm-release ./. {
  spec.chart.spec.sourceRef.name = "grafana";
}
