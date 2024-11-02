builtins.attrValues (
  builtins.mapAttrs (name: spec: {
    apiVersion = "kustomize.toolkit.fluxcd.io/v1";
    kind = "Kustomization";
    metadata = {
      inherit name;
      namespace = "flux-system";
    };
    spec =
      {
        targetNamespace = "kube-system";
        commonMetadata.labels."app.kubernetes.io/name" = name;
        prune = false; # should never be deleted
        sourceRef = {
          kind = "OCIRepository";
          name = "flux-system";
        };
        wait = true;
        interval = "30m";
        retryInterval = "1m";
        timeout = "5m";
      }
      // spec;
  })
  {
    cilium = {
      path = "./kube-system/cilium/app";
    };
    cilium-config = {
      path = "./kube-system/cilium/config";
      dependsOn = [
        {
          name = "cilium";
          namespace = "flux-system";
        }
      ];
    };
  }
)
# [ ]
# ---
# metadata:
#   name: &app cilium
#   namespace: flux-system
# spec:
#   targetNamespace: kube-system
#   commonMetadata:
#     labels:
#       app.kubernetes.io/name: *app
#   path: ./kube-system/cilium/app
#   prune: false # should never be deleted
#   sourceRef:
#     kind: OCIRepository
#     name: flux-system
#   wait: true
#   interval: 30m
#   retryInterval: 1m
#   timeout: 5m
# ---
# apiVersion: kustomize.toolkit.fluxcd.io/v1
# kind: Kustomization
# metadata:
#   name: &app cilium-config
#   namespace: flux-system
# spec:
#   targetNamespace: kube-system
#   commonMetadata:
#     labels:
#       app.kubernetes.io/name: *app
#   dependsOn:
#   - name: cilium
#     namespace: flux-system
#   path: ./kube-system/cilium/config
#   prune: false # should never be deleted
#   sourceRef:
#     kind: OCIRepository
#     name: flux-system
#   wait: false
#   interval: 30m
#   retryInterval: 1m
#   timeout: 5m

