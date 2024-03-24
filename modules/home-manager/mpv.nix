{ config
, lib
, sources
, ...
}:
let
  cfg = config.programs.mpv.catppuccin;
  enable = cfg.enable && config.programs.mpv.enable;
  palette = (lib.importJSON "${sources.palette}/palette.json").${cfg.flavour}.colors;
  themeDir = sources.mpv + /themes/${cfg.flavour};
in
{
  options.programs.mpv.catppuccin =
    lib.ctp.mkCatppuccinOpt "mpv" // {
      accent = lib.ctp.mkAccentOpt "mpv";
    };

  # Note that the theme is defined across multiple files
  config.programs.mpv = lib.mkIf enable {
    config = lib.ctp.fromINI (themeDir + "/mpv.conf");
    scriptOpts.stats = lib.ctp.fromINI
      (themeDir + "/script-opts/stats.conf") // rec {
      # Convert #RRGGBB into BBGGRR
      plot_color = lib.trivial.pipe
        palette.${cfg.accent}.hex
        [
          # Strip initial #
          (color: builtins.substring 1 6 color)
          # Split into RR GG BB chunks
          (x: builtins.genList
            (n: builtins.substring (n * 2) 2 x) 3)
          lib.lists.reverseList
          lib.strings.concatStrings
        ];

      plot_bg_border_color = plot_color;
    };
  };
}
