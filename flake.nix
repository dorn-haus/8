{
  description = "Dornhaus Homelab";

  inputs = {
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };

    devenv.url = "github:cachix/devenv";
    flake-parts.url = "github:hercules-ci/flake-parts";
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";
    nix2container = {
      url = "github:nlewo/nix2container";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-devenv.url = "github:cachix/devenv-nixpkgs/rolling";

    talhelper.url = "github:budimanjojo/talhelper";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    devenv-root,
    nixpkgs,
    nixpkgs-devenv,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} (ctx @ {
      withSystem,
      flake-parts-lib,
      ...
    }: let
      inherit (flake-parts-lib) importApply;
      flakeModules = {
        ansible = importApply ./modules/ansible ctx;
        task = importApply ./modules/task (ctx // {inherit nixpkgs-devenv;});
      };
    in {
      systems = ["x86_64-linux"];
      imports = [inputs.devenv.flakeModule] ++ builtins.attrValues flakeModules;

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: let
        inherit (params) writeYAML;

        talhelper = inputs'.talhelper.packages.default;

        params = {
          inherit self;

          pkgs = pkgs // {inherit talhelper;};
          toYAML = pkgs.lib.generators.toYAML {};
        };
        params.writeYAML = src: (pkgs.formats.yaml {}).generate "${baseNameOf src}.yaml" (import src params);

        talconfig-yaml = writeYAML ./talos/talconfig.yaml.nix;
      in {
        devenv.shells.default = {
          name = self.lib.github.repo;
          devenv.root = let
            devenvRootFileContent = builtins.readFile devenv-root.outPath;
          in
            pkgs.lib.mkIf (devenvRootFileContent != "") devenvRootFileContent;

          packages = with pkgs; [
            age
            alejandra
            ansible
            cilium-cli
            fluxcd
            helmfile
            jq
            kubectl
            sops
            talhelper
            talosctl
            yq
            yq-go

            (wrapHelm kubernetes-helm {
              plugins = with kubernetes-helmPlugins; [
                helm-diff
              ];
            })
          ];

          env = {
            TALCONFIG = talconfig-yaml;
            TALSECRET = ./talos/talsecret.sops.yaml;
          };

          enterShell = ''
            export KUBECONFIG=$DEVENV_STATE/talos/kubeconfig
            export TALOSCONFIG=$DEVENV_STATE/talos/talosconfig
          '';
        };
      };
      flake = {
        inherit flakeModules;
        lib = import ./lib {
          inherit self;
          inherit (nixpkgs) lib;
        };
      };
    });
}
