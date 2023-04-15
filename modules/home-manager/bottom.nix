{ config, pkgs, lib, ... }:
let cfg = config.programs.bottom.catppuccin;
in {
  options.programs.bottom.catppuccin = with lib; {
    enable = mkEnableOption "Catppuccin theme";
    flavour = mkOption {
      type = types.enum [ "latte" "frappe" "macchiato" "mocha" ];
      default = config.catppuccin.flavour;
      description = "Catppuccin flavour for bottom";
    };
  };

  config.programs.bottom.settings = with builtins;
    with lib;
    with pkgs;
    mkIf cfg.enable (fromTOML (readFile (fetchFromGitHub {
      owner = "catppuccin";
      repo = "bottom";
      rev = "c0efe9025f62f618a407999d89b04a231ba99c92";
      sha256 = "sha256-VaHX2I/Gn82wJWzybpWNqU3dPi3206xItOlt0iF6VVQ=";
    } + "/themes/${cfg.flavour}.toml")));
}
