{self, ...}: let
  inherit (self.lib) cluster;
  inherit (cluster.network) external;
in
  builtins.attrValues (
    builtins.mapAttrs (name: spec: {
      inherit spec;

      kind = "CiliumLoadBalancerIPPool";
      apiVersion = "cilium.io/v2alpha1";
      metadata = {
        name = "${cluster.name}-${name}";
        namespace = "kube-system";
      };
    })
    {
      ips.blocks = [{cidr = external.cidr4;}];
      ingress = {
        blocks = [{cidr = "${external.ingress}/32";}];
        serviceSelector.matchLabels."io.kubernetes.service.namespace" = "ingress-nginx";
      };
    }
  )
