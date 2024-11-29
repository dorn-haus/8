let
  vp = v: "v${v}"; # v prefix
in {
  # Format:
  # dep.datasource = [repository version transform]
  # If transform is not provided, the default is used: (v: v).
  cert-manager.helm = ["https://charts.jetstack.io" "1.16.2"];
  cilium.helm = ["https://helm.cilium.io" "1.16.4"];
  descheduler.helm = ["https://kubernetes-sigs.github.io/descheduler" "0.31.0"];
  external-secrets.helm = ["https://charts.external-secrets.io" "0.10.7"];
  flux-operator.helm = ["oci://ghcr.io/controlplaneio-fluxcd/charts" "0.10.0"];
  flux.github-releases = ["https://github.com/fluxcd/flux2" "2.4.0"];
  grafana.helm = ["https://grafana.github.io/helm-charts" "8.6.3"];
  inadyn.github-releases = ["https://github.com/troglobit/inadyn" "2.12.0" vp];
  inadyn.helm = ["https://charts.philippwaller.com" "1.1.0"];
  ingress-nginx.helm = ["https://kubernetes.github.io/ingress-nginx" "4.11.3"];
  kubernetes.github-releases = ["https://github.com/kubernetes/kubernetes" "1.31.2" vp];
  local-path-provisioner.github-releases = ["https://github.com/rancher/local-path-provisioner" "0.0.30" vp];
  loki.helm = ["https://grafana.github.io/helm-charts" "6.22.0"];
  minecraft-bedrock.helm = ["https://itzg.github.io/minecraft-server-charts" "2.8.1"];
  spegel.helm = ["oci://ghcr.io/spegel-org/helm-charts" "0.0.27" vp];
  talos.github-releases = ["https://github.com/siderolabs/talos" "1.8.2" vp];
  vector.helm = ["https://helm.vector.dev" "0.37.0"];
  zfs-localpv.helm = ["https://openebs.github.io/zfs-localpv" "2.6.2"];
}
