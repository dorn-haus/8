{withSystem, ...}: {...}: {
  perSystem = {
    system,
    pkgs,
    ...
  }: {
    packages.taskfile-yaml = withSystem system (
      {
        inputs',
        config,
        ...
      }: let
        writeYAML = (pkgs.formats.yaml {}).generate;
      in
        writeYAML "taskfile.yaml" {
          version = 3;

          tasks.default = {
            desc = "List all tasks";
            cmd = "task --list";
          };

          includes = with config.packages; {
            sops = taskfile-sops;
            talos = taskfile-talos;
          };
        }
    );
  };
}
