{ config, pkgs, lib, ... }:
let cfg = config.services.polybar.catppuccin;
in {
  options.services.polybar.catppuccin =
    lib.ctp.mkCatppuccinOpt "polybar" config;

  config.services.polybar.extraConfig = with builtins;
    with lib;
    with pkgs;
    mkIf cfg.enable (readFile (fetchFromGitHub
      {
        owner = "catppuccin";
        repo = "polybar";
        rev = "9ee66f83335404186ce979bac32fcf3cd047396a";
        sha256 = "sha256-bUbSgMg/sa2faeEUZo80GNmhOX3wn2jLzfA9neF8ERA=";
      } + "/themes/${cfg.flavour}.ini"));
}
