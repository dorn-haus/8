{
  zfsNode = {
    encrKeysDir = "/var/zfs/keys";
    nodeSelector.matchLabels."openebs.io/engine" = "zfs-localpv";
  };
}
