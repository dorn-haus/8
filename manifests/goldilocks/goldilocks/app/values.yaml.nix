let
  component = {
    resources = {
      requests = {
        cpu = "25m";
        memory = "256Mi";
      };
      limits = {
        cpu = "100m";
        memory = "1Gi";
      };
    };

    revisionHistoryLimit = 2;
  };
in {
  controller = component;
  dashboard = component;
}
