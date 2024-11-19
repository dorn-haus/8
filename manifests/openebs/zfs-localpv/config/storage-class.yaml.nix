{
  kind = "StorageClass";
  apiVersion = "storage.k8s.io/v1";
  metadata.name = "openebs-zfspv";
  parameters = {
    recordsize = "128k";
    compression = "off";
    dedup = "off";
    fstype = "zfs";
    poolname = "zfspv";
  };
  provisioner = "zfs.csi.openebs.io";
  reclaimPolicy = "Retain";
}
