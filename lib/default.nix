inputs @ {lib, ...}: {
  cluster = import ./cluster inputs;
  eui64 = import ./eui64.nix inputs;
  hex = import ./hex.nix inputs;

  yaml = {
    format = lib.generators.toYAML {};

    write = params @ {
      pkgs,
      src,
      ...
    }:
      (pkgs.formats.yaml {}).generate "${baseNameOf src}.yaml" (import src (params // inputs));
  };
}
