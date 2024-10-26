inputs @ {lib, ...}: {
  cluster = import ./cluster inputs;
  eui64 = import ./eui64.nix inputs;
  hex = import ./hex.nix inputs;

  yaml = {
    format = lib.generators.toYAML {};

    write = src: params @ {pkgs, ...}:
      (pkgs.formats.yaml {}).generate "${baseNameOf src}.yaml" (import src (params // inputs));
  };
}
