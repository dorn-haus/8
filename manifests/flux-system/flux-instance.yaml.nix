{self, ...}: let
  inherit (self.lib) cluster;
in {
  apiVersion = "fluxcd.controlplane.io/v1";
  kind = "FluxInstance";
  metadata = {
    name = "flux";
    namespace = "flux-system";
  };
  spec = {
    distribution = {
      version = "2.4.x";
      registry = "ghcr.io/fluxcd";
      artifact = "oci://ghcr.io/controlplaneio-fluxcd/flux-operator-manifests";
    };
    sync = {
      kind = "OCIRepository";
      url = with cluster.github; "oci://${registry}/${owner}/${repository}";
      ref = "latest";
      path = ".";
      pullSecret = "ghcr-auth";
    };
    cluster = {
      type = "kubernetes";
      networkPolicy = true;
      domain = cluster.domain;
    };
  };
}
