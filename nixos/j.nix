{ config, pkgs, nixpkgs, localpkgs, inputs, settings, ... }:
let
  vaapiIntelHybrid = pkgs.vaapiIntel.overrideAttrs { enableHybridCodec = true; };
  # hyprland = inputs.hyprland.override (old: { submodules = true; });
  hyprland = inputs.hyprland;
  pkgs-unstable = hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    ./apps/OpenTabletDriver.nix
    ./apps/sway.nix
    ./apps/docker.nix
    ./apps/mysql.nix
    # ./apps/miracast.nix
    ./apps/polkit_gnome.nix
  ];

  nix.settings = {   # hyprland cachix
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  environment.pathsToLink = [ "/share/zsh" ];

  environment.sessionVariables = {
    # some of these could be moved to home-manager
    # QT_QPA_PLATFORM = "wayland";  # already set in hyprland
    # GDK_BACKEND = "wayland";
    #QT_QPA_PLATFORMTHEME = "qt5ct";  # overridden by nix's own qt
    TESTNIXJ = "1";
    LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";
    # AQ_DRM_DEVICES = "\"/dev/dri/by-path/pci-0000\:01\:00.0-card\"";
    NIXQCONFPATH = "${settings.confpath}";
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      font-awesome
      powerline-fonts
      powerline-symbols
      wine64Packages.fonts
      wine64Packages.waylandFull
      corefonts
      cabin

      wqy_zenhei
      wqy_microhei
      
      lexend
      material-symbols
    ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
    fontconfig = {
      localConf = '''';  # xml
      defaultFonts = {
        serif = [ "Mononoki Nerd Font Mono" ];
        sansSerif = [ "Mononoki Nerd Font Mono" ];
        monospace = [ "Mononoki Nerd Font Mono" ];
      };
    };
  };

  # create /var/cache/tuigreet for tuigreet cache
  systemd.tmpfiles.rules = [
    "d /var/cache/tuigreet 0755 greeter greeter"
  ];
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''${pkgs.greetd.tuigreet}/bin/tuigreet --remember --cmd "Hyprland >> ~/tmp/hyprland.log 2>&1" --greeting "Welcome to your computer." --time --asterisks --asterisks-char "#" '';
        user = "greeter";
      };
    };
  };

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
  programs.dconf.enable = true;

  # hyprland-related wayland config
  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${settings.systemtype}.hyprland;
    # package = pkgs.hyprland;
    portalPackage = hyprland.packages.${settings.systemtype}.xdg-desktop-portal-hyprland;
  };

  programs.zsh = {
    enable = true;
  };
  programs.nm-applet = {
    enable = true;
  };
  
 programs.git = {
   enable = true;
   lfs.enable = true;
 };
  
  environment.systemPackages = [
    pkgs.nix
    pkgs.perl
    #home-manager
    #hyprland
    pkgs.kitty
    pkgs.mako
    pkgs.greetd.tuigreet
    pkgs.polkit
    pkgs.zsh
    pkgs.light
    # swaylock
    pkgs.swaylock-effects
    pkgs.gtklock
    pkgs.waylock
    pkgs.appimage-run
    pkgs.mpd
    pkgs.bluez
    pkgs.bluez-tools
    pkgs.xwayland

    pkgs.libsForQt5.qt5.qtwayland
    pkgs.libsForQt5.qt5ct
    pkgs.libva

    pkgs.pw-volume
    pkgs.wireplumber
    pkgs.libinput
    pkgs.libinput-gestures
    #xorg.xorgserver
    #xorg.xinput

    pkgs.dex  # desktop autoentries
    pkgs.btrfs-progs

    # pkgs.mesa
    pkgs.lm_sensors
    pkgs.glxinfo
    
    pkgs.libsForQt5.qt5.qtwayland
    pkgs.qt6.qtwayland

    pkgs.pkg-config
    pkgs.libnotify

    pkgs.efibootmgr
    pkgs.ntfs3g
  ];

  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = "experimental-features = nix-command flakes";
  };

  # https://www.reddit.com/r/NixOS/comments/1d7zvgu/nvim_cant_find_standard_library_headers/
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;
  services.upower.enable = true;
  programs.light.enable = true;

  services.udisks2.enable = true;

  services.fprintd = {
    enable = true;
    package = pkgs.fprintd;
    #tod = {
      #enable = true;
      #driver = pkgs.libfprint-2-tod1-goodix-550a;
    #};
  };

  services.seatd.enable = true;
  services.seatd.user = settings.username;

  hardware.graphics = {
    enable = true;
    # driSupport = true;
    # driSupport32Bit = true;
    # package = pkgs-unstable.mesa.drivers;  # use Hyprland's mesa drivers
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      # vaapiIntelHybrid  # LIBVA_DRIVER_NAME=i965
      vaapiVdpau
      libvdpau-va-gl
      nvidia-vaapi-driver  # LIBVA_DRIVER_NAME=nvidia
    # ] ++ [
    #   pkgs-unstable.mesa.drivers  # use Hyprland's mesa drivers
    ];
  };
  # https://www.youtube.com/watch?v=61wGzIv12Ds
  # nvidia.modesetting.enable = true;

  xdg.portal = {
    enable = true;
    # wlr = {
    #   enable = true;
    #   settings.screencast = {
    #     output_name = "HDMI-A-1";
    #     max_fps = 30;
    #     chooser_type = "simple";
    #     chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
    #   };
    # };
    config = {
      common = {
        Hyprland = [
          "hyprland"
          "gtk"
          "wlr"
        ];
        #"org.freedesktop.impl.portal.AppChooser"=["kde"];
        # this doesn't work
        #"org.freedesktop.impl.portal.FileChooser"=["kde"];
        # "org.freedesktop.impl.portal.ScreenCast"=["wlr"];
        # "org.freedesktop.impl.portal.Screenshot"=["wlr"];

        "org.freedesktop.impl.portal.ScreenCast"=["hyprland"];
        "org.freedesktop.impl.portal.Screenshot"=["hyprland"];
      };
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      # pkgs.xdg-desktop-portal-kde
      # pkgs.xdg-desktop-portal-wlr
      #pkgs.xdg-desktop-portal-hyprland
      # inputs.xdg-desktop-portal-hyprland
    ];
  };

  programs.gnupg = {
    agent.enable = true;
  };

  time.hardwareClockInLocalTime = true;

  #services.xserver = {
  #  layout = "us,fr";
  #  xkbVariant = ",";
  #  xkbOptions = "grp:win_space_toggle";
  #};
  #services.xserver.exportConfiguration = true;
  
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "zh_CN.UTF-8/UTF-8"
    "ja_JP.UTF-8/UTF-8"
  ];
  
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  users.users.${settings.username}.shell = pkgs.zsh;

  #HandlePowerKey=ignore
  #HandleLidSwitch=ignore
  #HandleLidSwitchExternalPower=ignore
  services.logind.extraConfig = ''
    HandlePowerKeyLongPress=poweroff
  '';

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  programs.xfconf.enable = true;
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  services.dbus = {
    enable = true;
    packages = [
      pkgs.xfce.thunar
      #pkgs.libsForQt5.dolphin
    ];
  };

  security.polkit = {
    enable = true;
  };
  security.pam.services.swaylock = {};
  security.pam.services.waylock = {};
  security.pam.services.gtklock = {};

  # Set limits for esync.
  systemd.extraConfig = "DefaultLimitNOFILE=1048576:1048576";
  systemd.user.extraConfig = "DefaultLimitNOFILE=1048576:1048576";

  # security.pam.loginLimits = [{
  #     domain = "*";
  #     type = "hard";
  #     item = "nofile";
  #     value = "1048576";
  # }];

  # somehow this works for esync limits for lutris, but the above doesn't
  security.pam = {
   loginLimits = [
     { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
     { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
     { domain = "@audio"; item = "nofile"; type = "soft"; value = "1048576"; }
     { domain = "@audio"; item = "nofile"; type = "hard"; value = "1048576"; }
   ];
  };

  musnix = {
    enable = true;
    alsaSeq.enable = true;
    soundcardPciId = "00:1f.3";
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
}
