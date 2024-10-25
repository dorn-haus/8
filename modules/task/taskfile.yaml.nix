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
    sops = include ./taskfiles/sops.yaml.nix;
    talos = include ./taskfiles/talos.yaml.nix;
  };
}
