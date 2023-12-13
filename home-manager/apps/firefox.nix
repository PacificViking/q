{ config, pkgs, flake-firefox-nightly, ... }:
{
  home.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
    MOZ_ENABLE_WAYLAND="1";
  };

  programs.firefox = {
    enable = true;
    #package = pkgs.firefox-devedition;
    package = flake-firefox-nightly.packages.${pkgs.system}.firefox-nightly-bin;
    policies = {};

    profiles.nightly-default = {
      path = "my1.nightly-default";
      settings = {
        "widget.wayland.vsync.enabled" = false;

        "browser.search.region" = "CA"; 
	"doh-rollout.home-region" = "CA";

        "widget.use-xdg-desktop-portal.file-picker" = 1;
	"widget.use-xdg-desktop-portal.location" = 1;
        "widget.use-xdg-desktop-portal.mime-handler" = 1;
	"widget.use-xdg-desktop-portal.open-uri" = 1;
	"widget.use-xdg-desktop-portal.settings" = 1;

	"browser.theme.toolbar-theme" = 1;
	"extensions.activeThemeID" = "default-theme@mozilla.org";

        "xpinstall.signatures.required" = false;
        "extensions.experiments.enabled" = true;
	"toolkit.legacyUserProfileCustomizations.stylesheets" = true;

	"browser.aboutConfig.showWarning" = false;
	"browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
	"browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
	"browser.newtabpage.activity-stream.feeds.section.topstories" = false;
	"browser.newtabpage.activity-stream.feeds.topsites" = false;
	"browser.safebrowsing.downloads.enabled" = false;
	"browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
	"browser.safebrowsing.downloads.remote.block_uncommon" = false;
	"browser.safebrowsing.malware.enabled" = false;
	"browser.safebrowsing.phishing.enabled" = false;

        "browser.startup.couldRestoreSession.count" = 3;
	"browser.urlbar.showSearchSuggestionsFirst" = false;
	"browser.urlbar.suggest.trending" = false;
	"datareporting.healthreport.uploadEnabled" = false;
        "browser.urlbar.quicksuggest.scenario" = "history";
	"browser.shell.checkDefaultBrowser" = false;
	"browser.shell.didSkipDefaultBrowserCheckOnFirstRun" = true;

        "dom.forms.autocomplete.formautofill" = true;
	"dom.security.https_only_mode" = true;
	"dom.security.https_only_mode_ever_enabled" = true;
	"network.trr.mode" = 3;
	"network.trr.uri" = "https://mozilla.cloudflare-dns.com/dns-query";

	"media.eme.enabled" = true;
	"privacy.donottrackheader.enabled" = true;
	"privacy.fingerprintingProtection" = true;
	"privacy.globalprivacycontrol.enabled" = true;
	"privacy.globalprivacycontrol.was_ever_enabled" = true;
	"privacy.query_stripping.enabled" = true;
	"privacy.query_stripping.enabled.pbmode" = true;
	"privacy.trackingprotection.emailtracking.enabled" = true;
	"privacy.trackingprotection.enabled" = true;
	"privacy.trackingprotection.socialtracking.enabled" = true;

	"toolkit.telemetry.reportingpolicy.firstRun" = false;
      };

      extraConfig = "";

      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ];

      id = 0;
      isDefault = true;

      search.force = true;
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
	"eBay".metaData.hidden = true;
	"Amazon.ca".metaData.hidden = true;
	"Bing".metaData.hidden = true;
        #"Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
      };
      # rose pine, remove close button
      userChrome = ''
.titlebar-buttonbox-container {
  display: none;
}
tab.tabbrowser-tab[selected="true"] .tab-label {
  color: #EBBCBA !important;
}
      '';
    };
  };
}
