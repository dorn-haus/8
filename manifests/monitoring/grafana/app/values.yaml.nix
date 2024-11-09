{self, ...}: {
  # Expose Grafana via an ingress path on the default hostname.
  ingress = {
    enabled = true;
    path = "/grafana";
    hosts = [self.lib.cluster.domain];

    # TODO: Set the default ingress class!
    ingressClassName = "nginx";

    # TODO: Enable SSL redirect:
    # extraPaths:
    # - path: /*
    #   pathType: Prefix
    #   backend:
    #     service:
    #       name: ssl-redirect
    #       port:
    #         name: use-annotation
  };

  # Allow spinning up a second replica. The default number of replicas is 1.
  autoscaling = {
    enabled = true;
    maxReplicas = 2;
  };
  podDisruptionBudget.minAvailable = 1;
}
