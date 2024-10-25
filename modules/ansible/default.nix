{...}: {self, ...}: {
  perSystem = {pkgs, ...}: {
    devenv.shells.default.env.ANSIBLE_INVENTORY = self.lib.yaml.write ./inventory.yaml.nix {inherit pkgs;};
  };
}
