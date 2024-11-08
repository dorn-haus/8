inputs @ {self, ...}: {
  cluster = import ../cluster {inherit self;};

  eui64 = import ./eui64.nix inputs;
  hex = import ./hex.nix inputs;
  nodes = import ./nodes.nix inputs;
  yaml = import ./yaml.nix inputs;

  cidr = net: len: "${net}/${toString len}";
}
