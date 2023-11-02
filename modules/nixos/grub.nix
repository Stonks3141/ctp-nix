{ config
, lib
, pkgs
, sources
, ...
}:
let
  cfg = config.boot.loader.grub.catppuccin;
  enable = cfg.enable && config.boot.loader.grub.enable;

  # TODO @getchoo: upstream this in nixpkgs maybe? idk if they have grub themes
  theme = pkgs.runCommand "catppuccin-grub-theme" { } ''
    mkdir -p "$out"
    cp -r ${sources.grub}/src/catppuccin-${cfg.flavour}-grub-theme/* "$out"/
  '';
in
{
  options.boot.loader.grub.catppuccin =
    lib.ctp.mkCatppuccinOpt "grub" config;

  config.boot.loader.grub = lib.mkIf enable {
    font = "${theme}/font.pf2";
    splashImage = "${theme}/background.png";
    inherit theme;
  };
}
