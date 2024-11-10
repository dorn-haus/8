{
  lib,
  self,
  ...
}: {
  crds.enabled = true;

  # HA config:
  replicaCount = 2;
  podDisruptionBudget = {
    enabled = true;
    minAvailable = 1;
  };

  # dns01RecursiveNameservers = "https://1.1.1.1:443/dns-query,https://1.0.0.1:443/dns-query";
  dns01RecursiveNameservers =
    lib.strings.concatStringsSep ","
    (map (ip: "https://${ip}:443/dns-query") self.lib.cluster.network.uplink.dns4.cloudflare);
  dns01RecursiveNameserversOnly = true;

  # prometheus = {
  #   enabled = true;
  #   servicemonitor.enabled = true;
  # };
}
