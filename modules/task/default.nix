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
    # Use go-task from the pkgs-devenv repo.
    # This is a temporary workaround while the one in the nixpkgs repo won't build.
    pkgs-devenv = import nixpkgs-devenv {inherit system;};

    env = "TASKFILE";
    taskfile-yaml = self.lib.yaml.write ./taskfile.yaml.nix {inherit inputs' pkgs;};
    task-wrapper = pkgs.writeShellScriptBin "task" ''
      ${pkgs.lib.getExe' pkgs-devenv.go-task "task"} --taskfile=${"$" + env} $@
    '';
  in {
    devenv.shells.default = {
      env.${env} = taskfile-yaml;
      packages = [task-wrapper];
    };
  };
}
