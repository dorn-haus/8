{...}: {self, ...}: {
  perSystem = {pkgs, ...}: {
    devenv.shells.default.env.TALCONFIG = self.lib.yaml.write ../../talos/talconfig.yaml.nix {inherit pkgs;};
  };
}
