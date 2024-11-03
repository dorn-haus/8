{self, ...}: {
  kind = "CiliumL2AnnouncementPolicy";
  apiVersion = "cilium.io/v2alpha1";
  metadata.name = "${self.lib.cluster.name}-ips-l2-policy";
  spec = {
    loadBalancerIPs = true;
    nodeSelector = {
      matchLabels."kubernetes.io/arch" = "amd64";
      matchExpressions = [
        {
          key = "node-role.kubernetes.io/control-plane";
          operator = "DoesNotExist";
        }
      ];
    };
    serviceSelector.matchLabels."app.kubernetes.io/instance" = "ingress-nginx";
  };
}
