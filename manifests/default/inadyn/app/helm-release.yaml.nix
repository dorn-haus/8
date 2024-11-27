{k, ...}:
k.fluxcd.helm-release ./. {
  spec.chart.spec.sourceRef.name = "philippwaller";
  spec.valuesFrom = [
    {
      kind = "Secret";
      name = "${baseNameOf (dirOf ./.)}-values";
    }
  ];
}
