{ config, pkgs, inputs, ... }:
{
  imports = [
    apps/waybar.nix
    apps/nvim.nix
    apps/python3.nix
    apps/sway.nix
    apps/fcitx.nix
    apps/firefox.nix
  ];
  
  home.username = "john";
  home.homeDirectory = "/home/john";

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
    pkgs.swaylock
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

    pkgs.xfce.thunar
    pkgs.xfce.xfce4-icon-theme
    pkgs.xfce.thunar-volman
    pkgs.xfce.tumbler
    pkgs.gvfs
    pkgs.polkit_gnome
    pkgs.xdg-utils
    pkgs.easyeffects

    pkgs.egl-wayland
    
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
    pkgs.ardour
    pkgs.zrythm
    pkgs.muse
    pkgs.netsurf.browser

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
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${builtins.toString ./.}/config/waybar";
    ".config/mpd".source = config.lib.file.mkOutOfStoreSymlink "${builtins.toString ./.}/config/mpd";

    ".config/neofetch" = {
      source = ./config/neofetch;
      recursive = true;
    };
    ".config/xdg-desktop-portal" = {
      source = ./config/xdg-desktop-portal;
      recursive = true;
    };
    ".config/hypr" = {
      source = ./config/hypr;
      recursive = true;
    };
    #".config/hypr".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/config/hypr";

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


  programs.zsh = {
    shellAliases = {  # shellGlobalAliases for replace anywhere
      "open" = "xdg-open";
      "jj_hm" = "home-manager switch --flake ~/q";
      "jj_nix" = "sudo nixos-rebuild switch --flake /home/john/q";

      "j_listInputs" = "sudo libinput list-devices";
      "j_listHyprDevices" = "hyprctl devices";
      "j_nixSearch" = "nix-env -qa";
      "j_manNix" = "man configuration.nix";
      "j_manHNix" = "man home-configuration.nix";
      "j_gitDiff" = "git diff HEAD";
      "j_listDevices" = "lspci -v";
      "j_systemInfo" = "inxi -Fzxx";
      "j_chown" = "sudo chown john:users";
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
