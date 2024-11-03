{self, ...}: let
  inherit (self.lib) cluster;
in {
  kind = "OCIRepository";
  apiVersion = "source.toolkit.fluxcd.io/v1beta2";
  metadata = rec {
    name = "flux-system";
    namespace = name;
  };
  spec = {
    interval = "1m";
    url = with cluster.github; "oci://${registry}/${owner}/${repository}";
    ref.tag = "latest";
    secretRef.name = "ghcr-auth";
  };
}
