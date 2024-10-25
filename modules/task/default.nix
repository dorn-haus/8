{
  nixpkgs-devenv,
  withSystem,
  ...
}: {self, ...}: {
  perSystem = {
    system,
    inputs',
    pkgs,
    ...
  }: let
    pkgs-devenv = import nixpkgs-devenv {inherit system;};
    taskfile-yaml = self.lib.yaml.write ./taskfile.yaml.nix {inherit inputs' pkgs;};
    task-wrapper = pkgs.writeShellScriptBin "task" ''
      ${pkgs.lib.getExe' pkgs-devenv.go-task "task"} --taskfile=${taskfile-yaml} $@
    '';
  in {
    devenv.shells.default = {
      env.TASKFILE = taskfile-yaml;
      packages = [task-wrapper];
    };
  };
}
