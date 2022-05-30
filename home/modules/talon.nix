{self, ...}: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.talon.enable;
in {
  options.programs.talon.enable = lib.mkEnableOption "talon";

  config.home.packages = lib.mkIf cfg.enable [self.packages.${pkgs.system}.talon];
}
