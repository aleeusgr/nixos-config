{ self, nixpkgs, ... }:

{
  system = "x86_64-linux";

  modules =
    (with self.nixosModules; [ cachix flake virtualbox-demo ]) ++ [
      ./legacy/nixos.nix

      ./hardware/nixos.nix
      nixpkgs.nixosModules.notDetected
    ];
}
