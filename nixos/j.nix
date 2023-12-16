{ config, pkgs, nixpkgs, inputs, settings, ... }:
{
  imports = [
    #./apps/sway.nix
  ];
  
  environment.pathsToLink = [ "/share/zsh" ];

  environment.sessionVariables = {
    # some of these could be moved to home-manager
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "0";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
    #QT_QPA_PLATFORMTHEME = "qt5ct";  # overridden by nix's own qt
    TESTNIXJ = "1";
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      powerline-fonts
      powerline-symbols
      nerdfonts
    ];
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
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --cmd Hyprland ";
        user = "greeter";
      };
    };
  };

  programs.dconf.enable = true;

  # hyprland-related wayland config
  programs.hyprland = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
  };
  programs.nm-applet = {
    enable = true;
  };
  
 # programs.git = {
 #   enable = true;
 #   userName = "John Hao";
 #   userEmail = "johnhaoallwood@gmail.com";
 # };
  
  environment.systemPackages = with pkgs; [
    nix
    #home-manager
    #hyprland
    kitty
    mako
    greetd.tuigreet
    polkit
    zsh
    nerdfonts
    light

    pipewire
    pw-volume
    wireplumber
    libinput
    libinput-gestures
    #xorg.xorgserver
    #xorg.xinput

    dex  # desktop autoentries
    btrfs-progs

    tlp
    mesa
    lm_sensors
    glxinfo
    
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;
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

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  # https://www.youtube.com/watch?v=61wGzIv12Ds
  # nvidia.modesetting.enable = true;

  xdg.portal = {
    enable = true;
    wlr = {
      enable = true;
      settings.screencast = {
        output_name = "HDMI-A-1";
        max_fps = 30;
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
      };
    };
    config = {
      common = {
        Hyprland = [
          "gtk"
        ];
        #"org.freedesktop.impl.portal.AppChooser"=["kde"];
        # this doesn't work
        #"org.freedesktop.impl.portal.FileChooser"=["kde"];
        "org.freedesktop.impl.portal.ScreenCast"=["hyprland"];
        "org.freedesktop.impl.portal.Screenshot"=["hyprland"];
      };
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-hyprland
    ];
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

  services.dbus.enable = true;

  security.polkit = {
    enable = true;
  };
  #security.pam = {
  #  enable = true;
  #};
}
