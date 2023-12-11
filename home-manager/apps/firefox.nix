{ config, pkgs, ... }:
{
  home.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
    MOZ_ENABLE_WAYLAND="1";
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
    policies = {};

    profiles.dev-edition-default = {
      settings = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "xpinstall.signatures.required" = false;
        "extensions.experiments.enabled" = true;
      };
      path = "my1.dev-edition-default";
      extraConfig = "";

      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ];

      id = 0;
      isDefault = true;

      search.engines = {
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };

        "NixOS Wiki" = {
          urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
          iconUpdateURL = "https://nixos.wiki/favicon.png";
          updateInterval = 24 * 60 * 60 * 1000; # every day
          definedAliases = [ "@nw" ];
        };
        #"Bing".metaData.hidden = true;
        #"Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
      };
      userChrome = ''
        /* Remove close button*/ .titlebar-buttonbox-container{ display:none }
      '';
    };
  };
}
