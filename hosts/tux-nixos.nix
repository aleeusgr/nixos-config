{ self, nixpkgs, ... }:

{
  system = "x86_64-linux";

  modules =
    (with self.nixosModules; [ cachix flake kubernetes ]) ++ [
      ./legacy/tux-nixos.nix

      ./hardware/tux-nixos.nix
      nixpkgs.nixosModules.notDetected
    ];
}