{ config, pkgs, lib, ... }:
let cfg = config.programs.bat.catppuccin; in
{
  options.programs.bat.catppuccin =
    lib.ctp.mkCatppuccinOpt "bat" config;

  config = {
    programs.bat = lib.mkIf cfg.enable {
      config.theme = "Catppuccin-${cfg.flavour}";
      themes."Catppuccin-${cfg.flavour}" = builtins.readFile (pkgs.fetchFromGitHub
        {
          owner = "catppuccin";
          repo = "bat";
          rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
          sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
        } + /Catppuccin-${cfg.flavour}.tmTheme);
    };
  };
}
