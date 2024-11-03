ctx: {
  kind = "Kustomization";
  apiVersion = "kustomize.toolkit.fluxcd.io/v1";
  metadata = {
    name = "flux-system";
    namespace = "flux-system";
  };
  spec = {
    interval = "10m";
    force = true;
    prune = true;
    wait = true;
    sourceRef = let
      repo = import ./oci-repository.yaml.nix ctx;
    in {
      inherit (repo) kind;
      inherit (repo.metadata) name;
    };
  };
}
