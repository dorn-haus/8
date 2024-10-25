inputs @ {...}: {
  cluster = import ./cluster inputs;
  eui64 = import ./eui64.nix inputs;
  hex = import ./hex.nix inputs;
}
