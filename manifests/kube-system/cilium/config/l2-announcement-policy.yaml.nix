{self, ...}: {
  kind = "CiliumL2AnnouncementPolicy";
  apiVersion = "cilium.io/v2alpha1";
  metadata.name = "${self.lib.cluster.name}-ips-l2-policy";
  spec = {
    loadBalancerIPs = true;
    nodeSelector.matchLabels."kubernetes.io/arch" = "amd64";
  };
}
