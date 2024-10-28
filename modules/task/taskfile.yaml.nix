{
  self,
  pkgs,
  inputs',
  ...
}: {
  version = 3;

  tasks.default = {
    desc = "List all tasks";
    cmd = "task --list";
  };

  includes = let
    include = src: self.lib.yaml.write src {inherit inputs' pkgs;};
  in {
    flux = include ./taskfiles/flux.yaml.nix;
    sops = include ./taskfiles/sops.yaml.nix;
    talos = include ./taskfiles/talos.yaml.nix;
  };
}
