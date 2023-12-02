{ config, pkgs, nixpkgs, home-manager, ... }:
let
  nix1903 = import <19.03> {};
  nix2305 = import <23.05> {};
  unstable = import <unstable> {};
in {
  imports = [
    ./apps/sway.nix
  ];
  
  nixpkgs.config.allowUnfree = true;

  environment.pathsToLink = [ "/share/zsh" ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
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

  programs.hyprland = {
    enable = true;
  };
  programs.zsh = {
    enable = true;
  };
  programs.nm-applet = {
    enable = true;
  };
  
 # programs.dolphin = {
 #   enable = true;
 # };

 # programs.git = {
 #   enable = true;
 #   userName = "John Hao";
 #   userEmail = "johnhaoallwood@gmail.com";
 # };
  
  environment.systemPackages = with pkgs; [
    nix
    #hyprland
    kitty
    mako
    greetd.tuigreet
    polkit
    zsh
    nerdfonts
    light
    #fprintd

    pipewire
    pw-volume
    wireplumber
    libinput
    libinput-gestures
    #xorg.xorgserver
    #xorg.xinput

    #libappindicator-gtk3  # are these two really necessary?
    #libdbusmenu-gtk3
    dex

    tlp
    #xorg.xf86videonouveau
    mesa
    
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
    #pulse.enable = false;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;
  programs.light.enable = true;

  services.udisks2.enable = true;

  #services.fprintd = {
  #  enable = true;
  #  tod = {
  #    enable = true;
  #    driver = pkgs.libfprint-2-tod1-vfs0090;
  #  };
  #};

  hardware.opengl = {
    enable = true;
    driSupport = true;
  };
  # https://www.youtube.com/watch?v=61wGzIv12Ds
  # nvidia.modesetting.enable = true;

  xdg.portal = {
    enable = true;
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

  users.users.john.shell = pkgs.zsh;

  security.polkit.enable = true;
}
