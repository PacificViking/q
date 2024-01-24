{ config, pkgs, inputs, ... }:
{
  home.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
    MOZ_ENABLE_WAYLAND="1";
    MOZ_DISABLE_RDD_SANDBOX="1";
  };

  programs.firefox = {
    enable = true;
    #package = pkgs.firefox-devedition;
    package = inputs.flake-firefox-nightly.packages.${pkgs.system}.firefox-nightly-bin;
    policies = {};

    #profiles.dev-edition-default = {
    profiles.nightly-default = {
      #path = "my1.firefox-dev-edition-default";
      path = "my1.nightly-default";
      settings = {
        "widget.wayland.vsync.enabled" = false;
        "media.ffmpeg.vaapi.enabled" = true;

        "browser.search.region" = "CA"; 
        "doh-rollout.home-region" = "CA";

        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "widget.use-xdg-desktop-portal.location" = 1;
        "widget.use-xdg-desktop-portal.mime-handler" = 1;
        "widget.use-xdg-desktop-portal.open-uri" = 1;
        "widget.use-xdg-desktop-portal.settings" = 1;

        "browser.tabs.closeWindowWithLastTab" = false;
        "middlemouse.paste" = false;
        "browser.uidensity" = 1;
        "browser.compactmode.show" = true;

        "browser.theme.toolbar-theme" = 1;
        #"extensions.activeThemeID" = "default-theme@mozilla.org";  # this can be disabled to make it "work"ish
        "extensions.activeThemeID" = "{a046d296-3ec9-40f8-a15c-db401fb7d8e7}";  # rose pine moon

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
        
        "general.autoScroll" = true;
        "media.autoplay.default" = 5;
        "media.block-autoplay-until-in-foreground" = true;
        "media.block-play-until-document-interaction" = true;
        "media.block-play-until-visible" = true;

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
        "services.sync.prefs.sync-seen.privacy.trackingprotection.enabled" = true;
        
        "toolkit.telemetry.reportingpolicy.firstRun" = false;

        "toolkit.cosmeticAnimations.enabled" = false;
        "ui.prefersReducedMotion" = 1;
        "full-screen-api.warning.delay" = 50;
        "full-screen-api.warning.timeout" = 50;
        "full-screen-api.transition-duration.enter" = "0 0";
        "full-screen-api.transition-duration.leave" = "0 0";
        "full-screen-api.transition.timeout" = 0;

        "network.buffer.cache.size" = 262144;
        "network.buffer.cache.count" = 128;
        "network.http.max-connections" = 1800;
        "network.http.max-connections-per-server" = 32;
        "network.http.max-persistent-connections-per-server" = 12;
        "network.http.max-urgent-start-excessive-connections-per-host" = 10;
        "network.http.pacing.requests.burst" = 32;
        "network.http.pacing.requests.min-parallelism" = 10;
        "network.websocket.max-connections" = 400;
        "network.ssl_tokens_cache_capacity" = 32768;

        "browser.cache.disk.enable" = false;  # change these two if I don't have enough RAM
        "browser.cache.memory.enable" = true;
        #"media.cache_size" = 102400;
        "media.memory_caches_combined_limit_kb" = 102400;
        "image.mem.surfacecache.max_size_kb" = 102400;
        "browser.sessionstore.interval" = 15000;

        "browser.tabs.loadBookmarksInTabs" = true;
        "browser.link.open_newwindow.override.external" = 3;

        "image.mem.decode_bytes_at_a_time" = 65536;
        "image.http.accept" = "*/*";
        #https://www.reddit.com/r/firefox/comments/17hlkhp/what_are_your_must_have_changes_in_aboutconfig/

        "browser.uiCustomization.state" = ''
        {"placements":{"widget-overflow-fixed-list":["developer-button","fullscreen-button","characterencoding-button","screenshot-button","find-button","save-page-button","firefox-view-button"],"unified-extensions-area":["foxyproxy_eric_h_jung-browser-action","_ea6ccf94-00c4-4972-a28a-b9d3572b6131_-browser-action","sponsorblocker_ajay_app-browser-action","_32af1358-428a-446d-873e-5f8eb5f2a72e_-browser-action","savepage-we_dw-dev-browser-action","_48748554-4c01-49e8-94af-79662bf34d50_-browser-action","firefoxcolor_mozilla_com-browser-action","addon_fastforward_team-browser-action","_278b0ae0-da9d-4cc6-be81-5aa7f3202672_-browser-action","_testpilot-containers-browser-action","7esoorv3_alefvanoon_anonaddy_me-browser-action","firefox_tampermonkey_net-browser-action","_b86e4813-687a-43e6-ab65-0bde4ab75758_-browser-action","_c52f9e9f-dbe3-4ee4-9515-4cec6a51b551_-browser-action","_b9acf540-acba-11e1-8ccb-001fd0e08bd4_-browser-action","_4d787612-565e-4a13-be4d-574eb2979032_-browser-action","jid1-bofifl9vbdl2zq_jetpack-browser-action","_59812185-ea92-4cca-8ab7-cfcacee81281_-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","zoom-controls","urlbar-container","history-panelmenu","bookmarks-menu-button","library-button","logins-button","downloads-button","reset-pbm-toolbar-button","unified-extensions-button","ublock0_raymondhill_net-browser-action","extension_one-tab_com-browser-action","profiler-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["save-to-pocket-button","reset-pbm-toolbar-button","profiler-button","developer-button","_32af1358-428a-446d-873e-5f8eb5f2a72e_-browser-action","savepage-we_dw-dev-browser-action","_48748554-4c01-49e8-94af-79662bf34d50_-browser-action","firefoxcolor_mozilla_com-browser-action","addon_fastforward_team-browser-action","_278b0ae0-da9d-4cc6-be81-5aa7f3202672_-browser-action","ublock0_raymondhill_net-browser-action","_testpilot-containers-browser-action","7esoorv3_alefvanoon_anonaddy_me-browser-action","sponsorblocker_ajay_app-browser-action","firefox_tampermonkey_net-browser-action","_b86e4813-687a-43e6-ab65-0bde4ab75758_-browser-action","extension_one-tab_com-browser-action","_c52f9e9f-dbe3-4ee4-9515-4cec6a51b551_-browser-action","_ea6ccf94-00c4-4972-a28a-b9d3572b6131_-browser-action","_b9acf540-acba-11e1-8ccb-001fd0e08bd4_-browser-action","foxyproxy_eric_h_jung-browser-action","_4d787612-565e-4a13-be4d-574eb2979032_-browser-action","jid1-bofifl9vbdl2zq_jetpack-browser-action","_59812185-ea92-4cca-8ab7-cfcacee81281_-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","toolbar-menubar","TabsToolbar","unified-extensions-area","widget-overflow-fixed-list"],"currentVersion":20,"newElementCount":4}
        '';
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

        "GitHub" = {
          urls = [{ template = "https://github.com/search?q={searchTerms}&type=repositories"; }];
          iconUpdateURL = "https://github.com/favicon.ico";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "@gh" ];
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
