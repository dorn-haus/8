{
  master.replicaCount = 2;

  # Lower resource limits for workers.
  worker.resources.limits = {
    cpu = "50m";
    memory = "128Mi";
  };

  prometheus.enable = false; # todo
}
