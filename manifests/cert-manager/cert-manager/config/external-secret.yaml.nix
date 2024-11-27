{k, ...}:
k.external-secret ./. {
  name = "cloudflare-api-token";
  data.api-token = "{{ .cloudflare_api_token }}";
}
