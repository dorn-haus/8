{
  self,
  lib,
}: {
  name = "locker";
  domain = "dorn.haus";

  github = {
    owner = "attilaolah";
    repository = "homelab";
    registry = "ghcr.io";
  };

  network = import ./network.nix {inherit self;};
  versions = import ./versions.nix;

  nodes = let
    inherit (builtins) filter listToAttrs;
    inherit (lib.lists) unique;

    all = self.lib.nodes ./nodes;
    byOS = os: {
      name = os;
      value = filter (node: node.os == os) all;
    };
  in {
    inherit all;
    by = {
      controlPlane = filter ({controlPlane, ...}: controlPlane) all;
      os = listToAttrs (map byOS (unique (map ({os, ...}: os) all)));
    };
  };
}
