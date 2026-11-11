{
  description = "Tailnet: Headscale control server behind Caddy";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    nixosModules.default = import ./module.nix;
  };
}
