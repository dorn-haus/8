{self, ...}: let
  inherit (self.lib) cluster;
in {
  kind = "CiliumLoadBalancerIPPool";
  apiVersion = "cilium.io/v2alpha1";
  metadata = {
    name = "${cluster.name}-ips";
    namespace = "kube-system";
  };
  spec.blocks = [{cidr = cluster.network.external.cidr4;}];
}
