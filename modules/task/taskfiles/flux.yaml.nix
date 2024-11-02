{pkgs, ...}: let
  inherit (pkgs.lib) getExe getExe';

  chmod = getExe' pkgs.coreutils "chmod";
  echo = getExe' pkgs.coreutils "echo";
  flux = getExe pkgs.fluxcd;
  helm = getExe pkgs.kubernetes-helm;
  kubectl = getExe' pkgs.kubectl "kubectl";
  mkdir = getExe' pkgs.coreutils "mkdir";
  nix = getExe pkgs.nix;
  rm = getExe' pkgs.coreutils "rm";
  tar = getExe pkgs.gnutar;
  xargs = getExe' pkgs.findutils "xargs";
  yq = getExe pkgs.yq;

  manifests = "$DEVENV_STATE/manifests";

  build = pkgs.writeShellScript "flux-build" ''
    cd "$DEVENV_ROOT"
    ${rm} --recursive --force "${manifests}"
    ${mkdir} --parents "${manifests}"
    ${nix} build --print-out-paths |
      ${xargs} ${tar} --directory "${manifests}" --extract --file
    ${chmod} +w --recursive "${manifests}"
  '';
  diff = pkgs.writeShellScript "flux-diff" ''
    ${flux} diff kustomization flux-system \
      --local-sources=OCIRepository/flux-system/flux-system=${manifests} \
      --path="${manifests}" \
      --recursive
  '';
in {
  version = 3;

  tasks = {
    build = {
      desc = "OCI image build + unpack locally";
      cmd = build;
      silent = true;
    };

    diff = {
      desc = "OCI image build + unpack + diff locally";
      cmds = [
        {task = "build";}
        diff
      ];
      silent = true;
    };

    push = {
      desc = "Upload OCI image to the registry";
      cmd = ''
        cd "$DEVENV_ROOT"
        ${nix} run .#oci-push
      '';
      silent = true;
    };

    install-operator = let
      name = "flux-operator";
      namespace = "flux-system";
      version = "0.10.0";
    in {
      desc = "Install the ${name}";
      status = [
        ''
          installed_version=$(
            ${helm} list -n ${namespace} -o yaml |
              ${yq} '.[] | select(.name == "${name}") | .app_version' -r
          )
          [ "$installed_version" = "v${version}" ]
        ''
      ];
      cmd = ''
        ${echo} "Installing ${name} version ${version}…"
        ${helm} install ${name} oci://ghcr.io/controlplaneio-fluxcd/charts/${name} \
          --namespace=${namespace} --create-namespace \
          --version=${version}
      '';
      silent = true;
    };

    install-instance = let
      name = "flux";
      namespace = "flux-system";
    in {
      desc = "Install Flux instance ${namespace}/${name}";
      status = [
        ''${kubectl} --namespace="${namespace}" get fluxinstance "${name}"''
      ];
      cmd = ''
        ${yq} < "$MANIFESTS" '
          select(.kind == "FluxInstance") |
          select(.metadata.namespace == "${namespace}") |
          select(.metadata.name == "${name}")
        ' | ${kubectl} apply --filename=-
      '';
      silent = true;
    };
  };
}
