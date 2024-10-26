{
  self,
  pkgs,
  ...
}: {
  repositories = [
    {
      name = "cilium";
      url = "https://helm.cilium.io";
    }
  ];
  releases = [
    {
      name = "cilium";
      namespace = "kube-system";
      chart = "cilium/cilium";
      version = "1.16.3";
      wait = true;
      values = [
        (self.lib.yaml.write ./cilium-values.yaml.nix {inherit pkgs;})
      ];
    }
  ];
}
