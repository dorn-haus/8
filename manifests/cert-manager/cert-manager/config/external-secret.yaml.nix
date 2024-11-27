{k, ...}:
k.external-secret ./. rec {
  metadata.name = "cloudflare-api-token";
  spec.target = {
    inherit (metadata) name;
    template.data.api-token = "{{ .cloudflare_api_token }}";
  };
}
