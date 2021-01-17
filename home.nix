{ pkgs, lib, ... }:
let
  nixPath = builtins.concatStringsSep ":" [
    "nixpkgs=${pkgs.inputs.nixpkgs-unstable}"
    "nixos-config=/etc/nixos/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  optionalImport = path:
    lib.optional (builtins.pathExists path) path;
in
{
  nixpkgs.config.allowUnfree = true;

  imports = [ ./modules ./profiles ]
    ++ optionalImport ./secrets.nix;

  profiles.base.enable = true;
  fonts.fontconfig.enable = true;

  systemd.user = {
    sessionVariables = { NIX_PATH = nixPath; };
  };

  manual.html.enable = true;

  xsession.windowManager.awesome.enable = true;

  home = {
    sessionVariables = { NIX_PATH = nixPath; };

    packages = with pkgs; [
      cachix
      niv
      # nix-prefetch-scripts
      nix-review
      (haskell.lib.doJailbreak haskellPackages.nixfmt)
      # nixfmt
      exercism
      tmate
      element-desktop
      powershell

      julia_15

      fira-code
      cascadia-code
    ];

    stateVersion = "20.09";
  };
}
