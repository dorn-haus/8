inputs: {
  cluster = import ../cluster inputs;

  eui64 = import ./eui64.nix inputs;
  hex = import ./hex.nix inputs;
  nodes = import ./nodes.nix inputs;
  yaml = import ./yaml.nix inputs;
  versions = import ./versions.nix;

  cidr = net: len: "${net}/${toString len}";
}
