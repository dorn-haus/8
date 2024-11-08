{
  lib,
  self,
  pkgs,
  ...
}: let
  inherit (builtins) elem head;
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.lists) flatten optional;
  inherit (self.lib) cluster yaml;

  node = node:
    {
      inherit (node) hostname controlPlane;

      ipAddress = node.ipv4;
      installDiskSelector.type = "ssd";
      networkInterfaces = [
        {
          deviceSelector.hardwareAddr = node.mac;
          addresses = [node.net4];
          routes = [
            {
              network = "0.0.0.0/0";
              gateway = cluster.network.uplink.gw4;
            }
            # IPv6 default route is auto-configured.
          ];
          dhcp = false;
        }
      ];

      kernelModules = optional node.zfs {name = "zfs";};

      schematic.customization.systemExtensions.officialExtensions = flatten [
        (optional (elem node.cpu ["intel" "amd"]) "siderolabs/${node.cpu}-ucode")
        (optional node.zfs "siderolabs/zfs")
      ];

      extraManifests = [
        (yaml.write ./manifests/watchdog.yaml.nix {inherit pkgs;})
      ];
    }
    // optionalAttrs node.zfs {
      nodeLabels.pvpool = "zfs";
    };
in {
  clusterName = cluster.name;
  talosVersion = "v1.8.2";
  kubernetesVersion = "v1.31.2";
  endpoint = "https://${(head cluster.nodes.by.controlPlane).ipv4}:6443";
  domain = cluster.domain;

  # Allow running jobs on control plane nodes.
  # Currently the control plane nodes don't do much anyway.
  allowSchedulingOnControlPlanes = true;

  nodes = map node cluster.nodes.by.os.talos;

  patches = map yaml.format [
    {
      cluster = {
        network = with cluster.network; {
          podSubnets = with pod; [cidr4 cidr6];
          serviceSubnets = with service; [cidr4 cidr6];
          cni.name = "none"; # we use cilium
        };
        # Use Cilium's KubeProxy replacement.
        proxy.disabled = true;
      };
      machine = {
        kubelet.nodeIP.validSubnets = with cluster.network.node; [cidr4 cidr6];
        network.nameservers = with cluster.network.uplink; dns4.two ++ dns6.two;
      };
    }
  ];
}
