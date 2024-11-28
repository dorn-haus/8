{
  # keep sorted
  github-releases.flux = ["https://github.com/fluxcd/flux2" "2.4.0"];
  github-releases.inadyn = ["https://github.com/troglobit/inadyn" "2.12.0"];
  github-releases.kubernetes = ["https://github.com/kubernetes/kubernetes" "1.31.2"];
  github-releases.local-path-provisioner = ["https://github.com/rancher/local-path-provisioner" "0.0.30"];
  github-releases.talos = ["https://github.com/siderolabs/talos" "1.8.2"];
  helm.cert-manager = ["https://charts.jetstack.io" "1.16.2"];
  helm.cilium = ["https://helm.cilium.io" "1.16.4"];
  helm.external-secrets = ["https://charts.external-secrets.io" "0.10.7"];
  helm.flux-operator = ["oci://ghcr.io/controlplaneio-fluxcd/charts" "0.10.0"];
  helm.grafana = ["https://grafana.github.io/helm-charts" "8.6.3"];
  helm.inadyn = ["https://charts.philippwaller.com" "1.1.0"];
  helm.ingress-nginx = ["https://kubernetes.github.io/ingress-nginx" "4.11.3"];
  helm.loki = ["https://grafana.github.io/helm-charts" "6.22.0"];
  helm.minecraft-bedrock = ["https://itzg.github.io/minecraft-server-charts" "2.8.1"];
  helm.spegel = ["oci://ghcr.io/spegel-org/helm-charts" "0.0.27"];
  helm.vector = ["https://helm.vector.dev" "0.37.0"];
  helm.zfs-localpv = ["https://openebs.github.io/zfs-localpv" "2.6.2"];
}
