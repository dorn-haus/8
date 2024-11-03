{...}: {self, ...}: {
  perSystem = {pkgs, ...}: {
    devenv.shells.default.env.TALCONFIG = self.lib.yaml.write ./talconfig.yaml.nix {inherit pkgs;};
  };
}
