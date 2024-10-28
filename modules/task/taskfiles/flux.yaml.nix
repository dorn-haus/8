{pkgs, ...}: let
  inherit (pkgs.lib) getExe getExe';

  chmod = getExe' pkgs.coreutils "chmod";
  flux = getExe pkgs.fluxcd;
  mkdir = getExe' pkgs.coreutils "mkdir";
  nix = getExe pkgs.nix;
  rm = getExe' pkgs.coreutils "rm";
  tar = getExe pkgs.gnutar;
  undocker = getExe pkgs.undocker;
  xargs = getExe' pkgs.findutils "xargs";
  zcat = getExe' pkgs.gzip "zcat";

  ociDir = "$DEVENV_STATE/oci";
  ociTar = "${ociDir}.tar";

  build = pkgs.writeShellScript "flux-build" ''
    cd "$DEVENV_ROOT"
    ${nix} build --print-out-paths |
      ${xargs} ${zcat} > "${ociTar}"

    ${chmod} +w --recursive "${ociDir}"
    ${rm} --recursive --force "${ociDir}"
    ${mkdir} --parents "${ociDir}"
    ${undocker} "${ociTar}" - |
      ${tar} --extract --directory "${ociDir}"
  '';
in {
  version = 3;

  tasks = {
    build = {
      desc = "OCI image build + unpack locally";
      cmd = build;
    };

    diff = {
      desc = "OCI image build + unpack + diff locally";
      cmds = [
        {task = "build";}
        ''${flux} diff kustomization flux-system --path "${ociDir}"''
      ];
    };
  };
}
