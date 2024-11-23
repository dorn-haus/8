{
  k,
  lib,
  ...
}: let
  inherit (builtins) elemAt;
  all = k.fluxcd.kustomization ./. {};
in [
  (elemAt all 0) # app
  (lib.attrsets.recursiveUpdate (elemAt all 1) {
    spec.dependsOn = [{name = "cert-manager-config";}];
  }) # config
]
