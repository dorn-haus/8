{k, ...}: {
  hostname = k.hostname ./.;

  # TODO: Figure out whether to expose this externally or not.
  # Definitely not until proper authentication is added, i.e. keycloak.
  ingress.enabled = false; # todo

  # TODO: Use the prod env, or just use our own certificates.
  letsEncrypt.environment = "staging";
}
