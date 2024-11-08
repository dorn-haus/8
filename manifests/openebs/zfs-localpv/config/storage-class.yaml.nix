{
  kind = "StorageClass";
  apiVersion = "storage.k8s.io/v1";
  metadata = {
    name = "openebs-zfspv";
    annotations."storageclass.kubernetes.io/is-default-class" = "true";
  };
  parameters = {
    recordsize = "128k";
    compression = "off";
    dedup = "off";
    fstype = "zfs";
    poolname = "zfspv";
  };
  provisioner = "zfs.csi.openebs.io";
}
