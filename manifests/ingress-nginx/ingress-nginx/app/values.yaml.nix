{self, ...}: {
  controller = {
    replicaCount = 2;
    ingressClassResource.default = true;
    service.annotations."lbipam.cilium.io/ips" = self.lib.cluster.network.external.ingress;
  };
}
