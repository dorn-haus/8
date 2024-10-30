{pkgs, ...}: let
  inherit (pkgs.lib) getExe getExe';

  chmod = getExe' pkgs.coreutils "chmod";
  echo = getExe' pkgs.coreutils "echo";
  flux = getExe pkgs.fluxcd;
  helm = getExe pkgs.kubernetes-helm;
  mkdir = getExe' pkgs.coreutils "mkdir";
  nix = getExe pkgs.nix;
  rm = getExe' pkgs.coreutils "rm";
  tar = getExe pkgs.gnutar;
  undocker = getExe pkgs.undocker;
  xargs = getExe' pkgs.findutils "xargs";
  zcat = getExe' pkgs.gzip "zcat";
  yq = getExe pkgs.yq;

  ociDir = "$DEVENV_STATE/oci";
  ociTar = "${ociDir}.tar";

  build = pkgs.writeShellScript "flux-build" ''
    cd "$DEVENV_ROOT"
    ${nix} build --print-out-paths |
      ${xargs} ${zcat} > "${ociTar}"

    ${rm} --recursive --force "${ociDir}"
    ${mkdir} --parents "${ociDir}"
    ${undocker} "${ociTar}" - |
      ${tar} --extract --directory "${ociDir}"
    ${chmod} +w --recursive "${ociDir}"
  '';
  diff = pkgs.writeShellScript "flux-diff" ''
    ${flux} diff kustomization flux-system \
      --local-sources=OCIRepository/flux-system/flux-system=${ociDir} \
      --path="${ociDir}" \
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
  };
}
