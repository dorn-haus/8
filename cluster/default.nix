{
  self,
  lib,
}: let
  inherit (builtins) elemAt filter mapAttrs listToAttrs;
  inherit (lib.lists) unique;
in {
  name = "locker";
  domain = "dorn.haus";

  github = {
    owner = "attilaolah";
    repository = "homelab";
    registry = "ghcr.io";
  };

  network = import ./network.nix {inherit self;};

  nodes = let
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

  versions = mapAttrs (datasource: projects: mapAttrs (project: value: elemAt value 1) projects) (import ./versions.nix);
}
