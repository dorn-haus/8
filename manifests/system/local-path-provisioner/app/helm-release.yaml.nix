{k, ...}:
k.fluxcd.helm-release ./. {
  spec.chart.spec = {
    chart = "./deploy/chart/${builtins.baseNameOf (builtins.dirOf ./.)}";
    sourceRef.kind = "GitRepository";
  };
}
