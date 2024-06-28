{
  config,
  options,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.swaync.catppuccin;
  # `services.swaync.catppuccin` is not readable when using mkSinkUndeclaredOptions
  # TODO: remove when 24.05 is stable
  enable = (options.services.swaync ? catppuccin) && cfg.enable && config.services.swaync.enable;
  # TODO wait on https://github.com/andir/npins/pull/46
  sources = {
    "swaync-latte" = builtins.fetchurl {
      url = "https://github.com/catppuccin/swaync/releases/download/v0.2.2/latte.css";
      sha256 = "sha256-701jarDOTKD8BYYiLEdQm4HIcVYFKRSaoJ/IeSytMrA=";
    };
    "swaync-frappe" = builtins.fetchurl {
      url = "https://github.com/catppuccin/swaync/releases/download/v0.2.2/frappe.css";
      sha256 = "sha256-/Y0FqRbun2dFnDHTyUvKYTesjH8f2N1n0ITzGR3PlWU=";
    };
    "swaync-macchiato" = builtins.fetchurl {
      url = "https://github.com/catppuccin/swaync/releases/download/v0.2.2/macchiato.css";
      sha256 = "sha256-EdpYKeeIJrnbjR98QQ4YXsNBsdrm6E2Nr7cmUBpTv6Y=";
    };
    "swaync-mocha" = builtins.fetchurl {
      url = "https://github.com/catppuccin/swaync/releases/download/v0.2.2/mocha.css";
      sha256 = "sha256-YFboTWj/hiJhmnMbGLtfcxKxvIpJxUCSVl2DgfpglfE=";
    };
  };
  themeRaw = sources."swaync-${cfg.flavor}";
  theme = pkgs.substitute {
    src = themeRaw;

    substitutions = [
      "--replace-warn"
      "Ubuntu Nerd Font"
      cfg.font
    ];
  };

  # `services.swaync` was added in 24.05 and not backported
  # TODO: remove when 24.05 is stable
  minVersion = "24.05";
in
{
  options.services.swaync = lib.ctp.mkVersionedOpts minVersion {
    catppuccin = lib.ctp.mkCatppuccinOpt "swaync" // {
      font = lib.mkOption {
        type = lib.types.str;
        default = "Ubuntu Nerd Font";
        description = "Font to use for the notification center";
      };
    };
  };

  config = lib.mkIf enable {
    services.swaync.style = theme;

    # Install the default font if it is selected
    home.packages = lib.mkIf (cfg.font == "Ubuntu Nerd Font") [
      (pkgs.nerdfonts.override { fonts = [ "Ubuntu" ]; })
    ];
  };
}
