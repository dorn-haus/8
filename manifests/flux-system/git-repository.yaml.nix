inputs @ {...}: let
  name = "local-path-provisioner";
in {
  kind = "GitRepository";
  apiVersion = "source.toolkit.fluxcd.io/v1";
  metadata = {
    inherit name;
    inherit ((import ./flux-instance.yaml.nix inputs).metadata) namespace;
  };
  spec = {
    interval = "1h";
    url = "https://github.com/rancher/${name}";
    ref.branch = "master";
    ignore = ''
      /*
      !/deploy/chart/local-path-provisioner/
    '';
  };
}
