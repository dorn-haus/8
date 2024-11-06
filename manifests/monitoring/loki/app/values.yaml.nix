{self, ...}: {
  loki = {
    schemaConfig.configs = [
      {
        from = "2024-11-06";
        store = "tsdb";
        object_store = "s3";
        schema = "v13";
        index = {
          prefix = "loki_index_";
          period = "24h";
        };
      }
    ];
    ingester.chunk_encoding = "snappy";

    # Default is 4, should increase this when having enough resources.
    querier.max_concurrent = 2;
    pattern_ingester.enabled = true;
    limits_config = {
      allow_structured_metadata = true;
      volume_enabled = true;
      retention_period = "${toString (24 * 7 * 4)}h";
    };
    compactor = {
      retention_enabled = true;
      delete_request_store = "s3";
    };
  };

  deploymentMode = "SimpleScalable";

  backend.replicas = 2;
  read.replicas = 2;

  # To ensure data durability with replication.
  write.replicas = 3;

  # Simple MinIO storage backend.
  # This will do for now; but will need to replace it eventually.
  minio.enabled = "true";

  gateway.service.type = "LoadBalancer";

  global.clusterDomain = self.lib.cluster.domain;
}
