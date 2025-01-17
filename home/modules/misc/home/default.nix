{
  nixpkgs-2105,
  unstable,
  self,
  ...
}: {
  config,
  pkgs,
  lib,
  ...
}: let
  self' = self.packages.x86_64-linux;
in {
  profiles.base.enable = true;
  fonts.fontconfig.enable = true;

  systemd.user = {
    # sessionVariables = { NIX_PATH = nixPath; };
  };

  xsession.windowManager.awesome.enable = true;

  home = {
    # sessionVariables = { NIX_PATH = nixPath; };

    packages = let
      p = pkgs;
      s = self';
    in [
      p.cachix
      p.element-desktop
      p.exercism
      p.nixpkgs-review
      p.tmate
      s."dracula/konsole"

      p.fira-code
      p.cascadia-code

      p.lefthook

      (p.writeShellScriptBin "timew" ''
        export TIMEWARRIORDB="${config.home.homeDirectory}/timmelzer@gmail.com/timewarrior"
        exec ${p.timewarrior}/bin/timew "$@"
      '')
    ];

    stateVersion = "20.09";
  };
}
