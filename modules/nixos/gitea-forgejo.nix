{
  config,
  lib,
  pkgs,
  ...
}:
let
  # theme = config.catppuccin.sources.gitea;
  theme = pkgs.fetchzip {
    url = "https://github.com/catppuccin/gitea/releases/download/v0.4.1/catppuccin-gitea.tar.gz";
    sha256 = "sha256-14XqO1ZhhPS7VDBSzqW55kh6n5cFZGZmvRCtMEh8JPI=";
    stripRoot = false;
  };

  mkForgeModule =
    forge:
    let
      cfg = config.services.${forge}.catppuccin;
      enable = cfg.enable && config.services.${forge}.enable;
    in
    {
      options.services.${forge}.catppuccin = lib.ctp.mkCatppuccinOpt forge // {
        accent = lib.ctp.mkAccentOpt forge;
      };

      config = lib.mkIf enable {
        systemd.services.${forge}.preStart =
          let
            customDir = config.services.${forge}.customDir;
            baseDir =
              if lib.versionAtLeast config.services.${forge}.package.version "1.21.0" then
                "${customDir}/public/assets"
              else
                "${customDir}/public";
          in
          lib.mkAfter ''
            rm -rf ${baseDir}/css
            mkdir -p ${baseDir}
            ln -sf ${theme} ${baseDir}/css
          '';

        services.${forge}.settings.ui = {
          DEFAULT_THEME = "catppuccin-${cfg.flavor}-${cfg.accent}";
          THEMES =
            let
              builtinThemes = {
                gitea = [
                  "auto"
                  "gitea"
                  "arc-greeen"
                ];
                forgejo = [
                  "forgejo-auto"
                  "forgejo-light"
                  "forgejo-dark"
                  "gitea-auto"
                  "gitea-light"
                  "gitea-dark"
                  "forgejo-auto-deuteranopia-protanopia"
                  "forgejo-light-deuteranopia-protanopia"
                  "forgejo-dark-deuteranopia-protanopia"
                  "forgejo-auto-tritanopia"
                  "forgejo-light-tritanopia"
                  "forgejo-dark-tritanopia"
                ];
              };
            in
            builtins.concatStringsSep "," (
              builtinThemes.${forge}
              ++ (map (name: lib.removePrefix "theme-" (lib.removeSuffix ".css" name)) (
                builtins.attrNames (builtins.readDir theme)
              ))
            );
        };
      };
    };
in
{
  imports = [
    (mkForgeModule "gitea")
    (mkForgeModule "forgejo")
  ];
}
