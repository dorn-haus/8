{k, ...}:
k.fluxcd.git-repository {
  local-path-provisioner.ignore = ''
    /*
    !/deploy/chart/local-path-provisioner/
  '';
}
