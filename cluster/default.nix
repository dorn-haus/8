{self}: {
  name = "locker";
  domain = "dorn.haus";

  github = {
    owner = "attilaolah";
    repository = "homelab";
    registry = "ghcr.io";
  };

  network = import ./network.nix {inherit self;};

  nodes = let
    inherit (builtins) filter listToAttrs;

    all = self.lib.nodes ./nodes;
    byOS = os: {
      name = os;
      value = filter (node: node.os == os) all;
    };
  in {
    inherit all;
    by = {
      controlPlane = filter (node: node.controlPlane) all;
      os = listToAttrs (map byOS ["alpine" "talos"]);
    };
  };
}
