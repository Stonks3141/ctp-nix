{ config
, lib
, sources
, ...
}:
let
  cfg = config.programs.fuzzel.catppuccin;
  enable = cfg.enable && config.programs.fuzzel.enable;
  themeFile = sources.fuzzel + /themes/${cfg.flavour}.ini;
  palette = (lib.importJSON "${sources.palette}/palette.json").${cfg.flavour}.colors;
in
{
  options.programs.fuzzel.catppuccin =
    lib.ctp.mkCatppuccinOpt "fuzzel" // {
      accent = lib.ctp.mkAccentOpt "fuzzel";
    };

  config.programs.fuzzel.settings = lib.mkIf enable
    (lib.recursiveUpdate
      (lib.ctp.fromINI themeFile)
      {
        colors = rec {
          match = palette."${cfg.accent}".hex + "ff";
          selection-match = match;
        };
      }
    );
}
