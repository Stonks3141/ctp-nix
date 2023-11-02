inputs: { config
        , pkgs
        , lib
        , ...
        }:
let
  extendedLib = import ../lib/mkExtLib.nix inputs.nixpkgs.lib;
  inherit (extendedLib) ctp;
in
{
  imports =
    let
      files = [
        ./alacritty.nix
        ./bat.nix
        ./bottom.nix
        ./btop.nix
        ./fish.nix
        ./kitty.nix
        ./lazygit.nix
        ./starship.nix
        ./helix.nix
        ./glamour.nix
        ./gtk.nix
        ./mako.nix
        ./neovim.nix
        ./micro.nix
        ./polybar.nix
        ./sway.nix
        ./tmux.nix
      ];
    in
    extendedLib.ctp.mapModules config pkgs extendedLib inputs files;

  options.catppuccin = {
    flavour = lib.mkOption {
      type = ctp.types.flavourOption;
      default = "latte";
      description = "Global Catppuccin flavour";
    };
    accent = lib.mkOption {
      type = ctp.types.accentOption;
      default = "teal";
      description = "Global Catppuccin accent";
    };
  };
}
