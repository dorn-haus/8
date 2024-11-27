{
  k,
  lib,
  ...
}:
k.external-secret ./. {
  name = "ghcr-auth";
  data.".dockerconfigjson" = let
    auth = "$AUTH";
    username = "flux";
  in
    # Replace JSON-encoded string to avoid escaping the quotes below.
    builtins.replaceStrings [auth] [
      ''{{ printf "${username}:%s" .ghcr_token | b64enc }}''
    ] (lib.strings.toJSON {
      auths."ghcr.io" = {
        inherit auth username;
        password = "{{ .ghcr_token }}";
      };
    });

  metadata.namespace = baseNameOf ./.;
  spec.target.template.type = "kubernetes.io/dockerconfigjson";
}
