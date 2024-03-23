{ config
, lib
, sources
, ...
}:
let
  cfg = config.programs.fzf.catppuccin;
  enable = cfg.enable && config.programs.fzf.enable;
  palette = (lib.importJSON "${sources.palette}/palette.json").${cfg.flavour}.colors;
in
{
  options.programs.fzf.catppuccin =
    lib.ctp.mkCatppuccinOpt "fzf";

  config.programs.fzf.colors = lib.mkIf enable
    # Manually populate with colors from catppuccin/fzf
    (lib.attrsets.mapAttrs (_: color: palette.${color}.hex)
      {
        "bg+" = "surface0";
        bg = "base";
        spinner = "rosewater";
        hl = "red";
        fg = "text";
        header = "red";
        info = "mauve";
        pointer = "rosewater";
        marker = "rosewater";
        "fg+" = "text";
        prompt = "mauve";
        "hl+" = "red";
      }
    );
}

