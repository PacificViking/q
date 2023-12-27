{ config, pkgs, inputs, settings, ... }:
{
  imports = [
    apps/waybar.nix
    apps/nvim.nix
    apps/python3.nix
    apps/sway.nix
    apps/fcitx.nix
    apps/firefox.nix
    apps/OpenTabletDriver.nix
  ];
  
  home.username = settings.username;
  home.homeDirectory = "/home/${settings.username}";

  home.stateVersion = "23.05"; # don't change

  #wayland.windowManager.hyprland = {
  #  enable = true;
  #};

  nixpkgs.overlays = [
    inputs.fenix.overlays.default
  ];

  home.packages = [
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs.nerdfonts
    pkgs.git
    pkgs.nodejs
    #pkgs.firefox-devedition
    pkgs.wofi
    pkgs.wl-clipboard
    pkgs.wl-clip-persist
    pkgs.hyprpaper
    pkgs.udisks
    pkgs.udisks2
    pkgs.udiskie
    #pkgs.swaylock
    pkgs.swaylock-effects
    pkgs.inxi
    
    pkgs.ffmpeg
    pkgs.grim
    pkgs.slurp
    pkgs.libnotify
    pkgs.hyprpicker
    pkgs.findutils
    pkgs.ripgrep
    pkgs.killall
    pkgs.bat
    pkgs.curl.dev

    pkgs.nodejs_21

    pkgs.xfce.thunar
    pkgs.xfce.xfce4-icon-theme
    pkgs.xfce.thunar-volman
    pkgs.xfce.tumbler
    pkgs.gvfs
    pkgs.polkit_gnome
    pkgs.xdg-utils
    pkgs.easyeffects

    pkgs.egl-wayland
    #pkgs.opentabletdriver
    #pkgs.wacomtablet
    #pkgs.xf86_input_wacom
    #pkgs.libwacom
    
    pkgs.neofetch
    pkgs.font-awesome

    pkgs.networkmanagerapplet
    pkgs.bluez
    pkgs.bluez-tools

    pkgs.xorg.setxkbmap
    pkgs.xkb-switch
    pkgs.xkblayout-state
    pkgs.perl538Packages.FileMimeInfo
    pkgs.xorg.xdpyinfo

    pkgs.mpd
    pkgs.mpdevil
    pkgs.mpc-cli
    pkgs.pms
    pkgs.hydrogen  # drum synthesizer
    #pkgs.vcv-rack
    pkgs.freepats
    pkgs.ChowKick
    pkgs.drumkv1
    pkgs.drumgizmo

    (pkgs.fenix.latest.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    pkgs.rust-analyzer-nightly
    pkgs.gcc
    pkgs.nil

    pkgs.webcord-vencord
    pkgs.libreoffice-fresh
    pkgs.zrythm
    pkgs.reaper
    pkgs.muse
    pkgs.netsurf.browser
    pkgs.xournalpp
    pkgs.gparted
    #pkgs.isoimagewriter

    pkgs.gnome.dconf-editor

    pkgs.qt5.full
    pkgs.libsForQt5.qt5ct
    pkgs.libsForQt5.qt5.qtwayland
    pkgs.libsForQt5.plasma-wayland-protocols
    pkgs.libsForQt5.dolphin
    pkgs.libsForQt5.kwayland
    pkgs.libsForQt5.kwayland-integration
    #pkgs.libsForQt5.qtstyleplugin-kvantum
    (pkgs.catppuccin-kvantum.override {accent = "Yellow"; variant = "Mocha";})
    pkgs.libsForQt5.breeze-icons

    #pkgs.qt6.qtwayland
    #pkgs.qt6.full
    #pkgs.qt6Packages.qt6ct
  ];

  home.file = {
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${settings.confpath}/home-manager/config/waybar";
    ".config/mpd".source = config.lib.file.mkOutOfStoreSymlink "${settings.confpath}/home-manager/config/mpd";

    ".config/gtk-3.0/bookmarks".source = ./config/gtk-3.0/bookmarks;

    ".config/neofetch" = {
      source = ./config/neofetch;
      recursive = true;
    };

    #".config/xdg-desktop-portal" = {
    #  source = ./config/xdg-desktop-portal;
    #  recursive = true;
    #};

    #".config/hypr" = {
    #  source = ./config/hypr;
    #  recursive = true;
    #};
    ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink "${settings.confpath}/home-manager/config/hypr";

    ".config/p10k.zsh" = {
      source = ./config/p10k.zsh;
    };
    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  xdg.mimeApps = {
    enable = true;
    associations.added = {
    };
    defaultApplications = {
      "application/html" = [ "firefox.desktop" ];
      "application/pdf" = [ "firefox.desktop" ];
      "inode/directory" = [ "thunar.desktop" ];
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    TESTHOME = "2";
  };

  xsession = {
    enable = true;
    windowManager.command = "emacs";
  };

  qt = {
    enable = true;
    platformTheme = "qtct";
    #style.name = "kvantum";
  };

  services.swayosd = {
    enable = true;
    maxVolume = 120;
  };


  programs.zsh = {
    shellAliases = {  # shellGlobalAliases for replace anywhere
      "open" = "xdg-open";
      "gparted" = "sudo env WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR gparted";
      "jj_hm" = "home-manager switch --flake ${settings.confpath}";
      "jj_nix" = "sudo nixos-rebuild switch --flake ${settings.confpath}";

      "j_listInputs" = "sudo libinput list-devices";
      "j_listHyprDevices" = "hyprctl devices";
      "j_nixSearch" = "nix-env -qa";
      "j_manNix" = "man configuration.nix";
      "j_manHNix" = "man home-configuration.nix";
      "j_gitDiff" = "git diff HEAD";
      "j_listDevices" = "lspci -v";
      "j_systemInfo" = "inxi -Fzxx";
      "j_chown" = "sudo chown john:users";
      "j_buildFlakeVM" = "nixos-rebuild build-vm --flake";
    };

    enable = true;
    enableAutosuggestions = false;
    enableCompletion = true;
    autocd = true;
    envExtra = "";
    initExtra = ''
      neofetch;
      source .config/p10k.zsh;
    '';
    
    oh-my-zsh = {
      enable = true;
      package = pkgs.oh-my-zsh;
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
	file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

  };

  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    font = {
      name = "Mononoki Nerd Font Mono";
    };
    keybindings = {
      "ctrl+tab" = "send_text normal,application \\x1b[9;5u";
    };
    settings = {
      enable_audio_bell = false;
    };
    theme = "Rosé Pine Moon";
    shellIntegration.enableZshIntegration = true;
  };

  programs.waybar = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
  };

  programs.git = {
    enable = true;
    extraConfig = {
      user.name = "John Hao";
      user.email = "johnhaoallwood@gmail.com";
      advice.addIgnoredFile = "false";
    };
  };

  services.mpd = {
    enable = true;
    musicDirectory = "~/Music";
  };

  #services.udisks.enable = true;
  #services.blueman-manager.enable = true;
  #services.blueman-applet = {
  #  enable = true;
  #};
  #services.network-manager-applet.enable = true;


  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 36;
  };

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.rose-pine-icon-theme;
      name = "rose-pine-moon";
    };
    theme = {
      package = pkgs.rose-pine-gtk-theme;
      name = "rose-pine-moon";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
