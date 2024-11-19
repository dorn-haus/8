{
  storageClass = {
    create = true;
    defaultClass = true;
    name = "local-path";
    reclaimPolicy = "Retain";
  };
  nodePathMap = [
    {
      node = "DEFAULT_PATH_FOR_NON_LISTED_NODES";
      paths = ["/var/local-path-provisioner"];
    }
  ];
}
