{ config, pkgs, lib, inputs, settings, localpkgs, masterpkgs, ... }:
let
  nvidiaDiscord = pkgs.discord-canary.overrideAttrs (old: {
    name = "nvidiaDiscordCanary";
    postInstall = ''
sed -i '2 i\export __NV_PRIME_RENDER_OFFLOAD=1\nexport __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0\nexport __GLX_VENDOR_LIBRARY_NAME=nvidia\nexport __VK_LAYER_NV_optimus=NVIDIA_only' $out/opt/DiscordCanary/DiscordCanary
    '';
  });

  rust-toolchain = pkgs.fenix.fromToolchainFile {
    file = ./config/rust-toolchain.toml;
    sha256 = "sha256-uzamZW0GCy8pEFLKcMjH1SnFwZEfmTipLadzYx97pVk=";
  };

  runcage = pkgs.writeTextFile {
   name = "runcage";
   destination = "/bin/runcage";
   executable = true;

   text = ''
    #!/usr/bin/env python3
    import sys
    import os
    args = sys.argv[1:]
    acc = ""
    brightness = 40
    for i in args:
      if "--brightness=" in i:
        brightness = int(i.replace("--brightness=", ""))
      else:
        acc += i
        acc += " "
    acc = acc[:-1]
    os.system(f"cage -s -- sh -c 'kanshi & brightnessctl set {brightness}% & {acc}'")
   '';
  };

  hyprland = inputs.hyprland;
  pkgs-unstable = hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    apps/misc.nix
    apps/waybar.nix
    apps/nvim.nix
    apps/python3.nix
    apps/sway.nix
    apps/fcitx.nix
    apps/firefox.nix
    apps/OpenTabletDriver.nix
    apps/dolphin.nix
    # apps/ags.nix
    apps/texlive.nix
    apps/clipboard.nix
    apps/element.nix
  ];
  
  home.username = settings.username;
  home.homeDirectory = "/home/${settings.username}";

  home.stateVersion = "23.05"; # don't change

  #wayland.windowManager.hyprland = {
  #  enable = true;
  #};

  # wayland.windowManager.hyprland = {
  #   enable = true;
  #
  #   plugins = [
  #     pkgs.hyprlandPlugins.hyprscroller
  #   ];
  #
  #   package = hyprland.packages.${settings.systemtype}.hyprland;
  #   portalPackage = hyprland.packages.${settings.systemtype}.xdg-desktop-portal-hyprland;
  # };

  # nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.permittedInsecurePackages = [
  #               "openssl-1.1.1w"
  #             ];

  nixpkgs.overlays = [
    inputs.fenix.overlays.default
  ];

  home.packages = [
    runcage

    localpkgs.wlvncc

    #localpkgs.hyprprop-rust
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    inputs.ignis.packages.${settings.systemtype}.ignis
    inputs.swww.packages.${settings.systemtype}.swww
    # pkgs.git
    # pkgs.git-lfs
    pkgs.sourcekit-lsp
    pkgs.pyfa
    pkgs.nodejs
    pkgs.ghc
    #pkgs.firefox-devedition
    pkgs.wofi
    pkgs.wl-clipboard
    pkgs.wl-clipboard-x11
    pkgs.wl-clip-persist
    pkgs.hyprpaper
    # pkgs.udisks
    # pkgs.udisks2
    # pkgs.udiskie
    pkgs.inxi
    pkgs.mercurialFull
    pkgs.dos2unix
    pkgs.yt-dlp
    pkgs.valgrind
    pkgs.gnumake
    pkgs.web-ext
    pkgs.ruff-lsp
    # pkgs.cutter
    # pkgs.ghidra
    # inputs.hyprprop-rust.defaultPackage.${settings.systemtype}
    pkgs.hyprprop
    pkgs.hyprcursor
    pkgs.win2xcur
    pkgs.xcur2png

    pkgs.ffmpeg
    pkgs.pciutils
    pkgs.grim
    pkgs.slurp
    pkgs.baobab  # disk usage analyzer
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    pkgs.hyprpicker
    pkgs.findutils
    pkgs.ripgrep
    # pkgs.killall
    pkgs.bat
    pkgs.curl.dev
    # pkgs.dfeet
    pkgs.d-spy
    pkgs.pqiv

    pkgs.nodejs_22

    #pkgs.gnome.nautilus
    pkgs.xfce.xfce4-icon-theme
    pkgs.xfce.xfce4-settings
    #pkgs.xfce.thunar-volman
    #pkgs.xfce.tumbler
    #pkgs.gvfs
    # pkgs.polkit_gnome
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

    pkgs.xorg.setxkbmap
    pkgs.xkb-switch
    pkgs.xkblayout-state
    pkgs.perl538Packages.FileMimeInfo
    pkgs.xorg.xdpyinfo

    pkgs.mpdevil
    pkgs.ncmpcpp
    pkgs.mpc-cli
    pkgs.pms
    pkgs.hydrogen  # drum synthesizer
    #pkgs.vcv-rack
    pkgs.freepats
    pkgs.ChowKick
    pkgs.drumkv1
    pkgs.drumgizmo
    pkgs.bitwig-studio

    rust-toolchain

    # pkgs.rust-analyzer  # is sometimes contained within rust-toolchain according to the toml file
    pkgs.mold-wrapped
    pkgs.gcc
    pkgs.nil
    pkgs.clang-tools
    pkgs.cage
    pkgs.wlr-randr
    pkgs.kanshi

    # pkgs.expressvpn
    pkgs.gpt4all-cuda
    pkgs.gnome-keyring

    (pkgs.discord-canary.override {
    # (nvidiaDiscord.override {
     # remove any overrides that you don't want
     # withOpenASAR = true;
     # withVencord = true;
    })
    # pkgs.discord
    # pkgs.vesktop
    pkgs.kdePackages.xwaylandvideobridge
    pkgs.element-desktop
    pkgs.wireguard-tools

    pkgs.gtk4
    pkgs.gtk4-layer-shell
    # using gtkcord until nvidia+wayland+electron gets fixed
    pkgs.gtkcord4
    pkgs.cheese
    # pkgs.webkitgtk_4_0
    # masterpkgs.webkitgtk_6_0
    # masterpkgs.webkitgtk_4_1
    # pkgs.wechat-uos
    # pkgs.discord
    # pkgs.webcord-vencord

    # pkgs.haskellPackages.sixel
    pkgs.libsixel
    pkgs.libcaca
    pkgs.w3m
    pkgs.imlib2
    (pkgs.ueberzugpp.override { enableOpencv = false; })
    pkgs.yazi
    pkgs.imagemagick
    pkgs.sox
    pkgs.libreoffice-fresh
    # pkgs.zrythm
    pkgs.reaper
    pkgs.muse
    # pkgs.netsurf.browser
    pkgs.xournalpp
    pkgs.gparted
    pkgs.isoimagewriter
    pkgs.qbittorrent
    pkgs.lutris
    pkgs.opencv
    pkgs.obs-studio
    pkgs.vlc
    # pkgs.archiver
    pkgs.file-roller
    pkgs.tor
    pkgs.tor-browser
    pkgs.teamspeak_client
    pkgs.tigervnc
    pkgs.sshfs
    pkgs.pdftk
    # pkgs.openjdk17-bootstrap
    pkgs.jdk
    pkgs.wine-wayland
    # inputs.prismlauncher-cracked.packages.${settings.systemtype}.prismlauncher
    pkgs.cargo-flamegraph
    (pkgs.octaveFull.override { enableQt = true; })
    pkgs.lazygit

    pkgs.dconf-editor
    pkgs.nvtopPackages.nvidia

    pkgs.qt5.full
    pkgs.libsForQt5.qt5ct
    pkgs.libsForQt5.qt5.qtwayland
    pkgs.libsForQt5.plasma-wayland-protocols
    #pkgs.libsForQt5.dolphin
    pkgs.libsForQt5.kwayland
    pkgs.libsForQt5.kwayland-integration
    #pkgs.libsForQt5.qtstyleplugin-kvantum
    (pkgs.catppuccin-kvantum.override {accent = "yellow"; variant = "mocha";})
    pkgs.libsForQt5.breeze-icons

    (pkgs.cudaPackages.cudatoolkit.override {cuda_gdb = null;})  # don't use cuda gdb which doesn't work for some reason, I dont need it
    pkgs.gdb

    pkgs.re2c
    pkgs.cmake
    (lib.hiPrio pkgs.clang)
    pkgs.jq

    #pkgs.qt6.qtwayland
    #pkgs.qt6.full
    #pkgs.qt6Packages.qt6ct

    pkgs.vkmark
    pkgs.glmark2
    pkgs.vulkan-tools
  ];

  xdg.desktopEntries.gtkcord = {
    name = "gtkcord";
    genericName = "discord";
    exec = "gtkcord4";
    terminal = false;
    categories = [ "GNOME" "GTK" "Network" "Chat" ];
    icon = "gtkcord4";
    startupNotify = true;
  };

  xdg.desktopEntries.pyfa = {
    name = "pyfa";
    genericName = "Python Fitting Assistant";
    exec = "pyfa";
    terminal = false;
    categories = [ "Engineering" ];
    startupNotify = true;
  };

  home.file = {
    ".icons".source = config.lib.file.mkOutOfStoreSymlink "${settings.confpath}/home-manager/icons";

    "p".source = config.lib.file.mkOutOfStoreSymlink "${settings.confpath}/programs";
    ".config/zshcompletions".source = config.lib.file.mkOutOfStoreSymlink "${settings.confpath}/home-manager/config/zshcompletions";

    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${settings.confpath}/home-manager/config/waybar";

    ".config/kanshi".source = config.lib.file.mkOutOfStoreSymlink "${settings.confpath}/home-manager/config/kanshi";

    ".config/Thunar".source = config.lib.file.mkOutOfStoreSymlink "${settings.confpath}/home-manager/config/Thunar";

    ".config/ignis".source = config.lib.file.mkOutOfStoreSymlink "${settings.confpath}/home-manager/config/ignis";

    ".config/mpd".source = config.lib.file.mkOutOfStoreSymlink "${settings.confpath}/home-manager/config/mpd";

    ".w3m/config".source = config.lib.file.mkOutOfStoreSymlink "${settings.confpath}/home-manager/config/w3m/config";

    ".config/gtklock".source = config.lib.file.mkOutOfStoreSymlink "${settings.confpath}/home-manager/config/gtklock";

    ".config/wofi".source = config.lib.file.mkOutOfStoreSymlink "${settings.confpath}/home-manager/config/wofi";

    ".config/gtk-3.0/bookmarks".source = config.lib.file.mkOutOfStoreSymlink "${settings.confpath}/home-manager/config/gtk-3.0/bookmarks";

    ".config/neofetch".source = config.lib.file.mkOutOfStoreSymlink "${settings.confpath}/home-manager/config/neofetch";

    #".config/xdg-desktop-portal" = {
    #  source = ./config/xdg-desktop-portal;
    #  recursive = true;
    #};

    #".config/hypr" = {
    #  source = ./config/hypr;
    #  recursive = true;
    #};
    ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink "${settings.confpath}/home-manager/config/hypr";

    ".local/bin/programs".source = config.lib.file.mkOutOfStoreSymlink "${settings.confpath}/programs/";

    ".config/p10k.zsh" = {
      source = ./config/p10k.zsh;
    };
    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionPath = [
    "${settings.confpath}/programs"
  ];

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "application/pdf" = [
        "com.github.xournalpp.xournalpp.desktop"
        "pqiv.desktop"
      ];
      "image/svg+xml" = [
        "firefox-nightly.desktop"
      ];
      "application/x-zerosize" = [ "nvim.desktop" ];
      "text/markdown" = [ "nvim.desktop" ];
      "inode/directory" = [ "thunar.desktop" ];
      "image/png" = [ "pqiv.desktop" "firefox-nightly.desktop" ];
      "video/x-matroska" = [ "vlc.desktop" ];
      "application/x-bat" = [ "nvim.desktop" ];
    };
    defaultApplications = {
      "application/vnd.mozilla.xul+xml" = [ "firefox-nightly.desktop" ];
      "application/xhtml+xml" = [ "firefox-nightly.desktop" ];
      "text/html" = [ "firefox-nightly.desktop" ];
      "text/xml" = [ "firefox-nightly.desktop" ];
      "x-scheme-handler/http" = [ "firefox-nightly.desktop" ];
      "x-scheme-handler/https" = [ "firefox-nightly.desktop" ];
      "x-scheme-handler/about" = [ "firefox-nightly.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox-nightly.desktop" ];

      "application/html" = [ "firefox-nightly.desktop" ];
      "application/pdf" = [ "firefox-nightly.desktop" ];
      "inode/directory" = [ "thunar.desktop" ];
      "video/mp4" = [ "vlc.desktop" ];
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    TESTHOME = "2";
    # XCURSOR_SIZE = 36;
  };

  xsession = {
    enable = true;
    windowManager.command = "emacs";
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    #style.name = "kvantum";
  };

  # services.swayosd = {
  #   enable = true;
  #   maxVolume = 120;
  # };

  programs.zsh = {
    shellAliases = {  # shellGlobalAliases for replace anywhere
      "open" = "xdg-open";
      "gparted" = "sudo env WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR gparted";
      "sudodisp" = "sudo env WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR";
      "clang-format-inplace" = "clang-format -i -style Google";
      "cc++" = "g++ -std=c++11 -Wall -o a.out";
      "matlab" = "octave";

      "jj_hm" = "home-manager switch --flake ${settings.confpath}";
      "jj_nix" = "sudo nixos-rebuild switch --flake ${settings.confpath}";

      "j_nixTree" = "nix-store -q --tree /run/current-system";
      "j_startIgnis" = "GSK_RENDERER=ngl ignis init";
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
      "j_colorPicker" = "grim -g \"$(slurp -p)\" -t ppm - | convert - -format '%[pixel:p{0,0}]' txt:-";
      "j_updateNixLocal" = "cd ~/q; nix flake lock --update-input localnixpkgs; cd -";
      "j_clearNvimSwap" = "rm ~/.local/state/nvim/swap/*";
      "j_mountWindows" = "sudo mkdir -p /run/media/john/Windows; sudo mount /dev/nvme0n1p3 /run/media/john/Windows";
    };

    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = false;
    enableCompletion = true;
    autocd = true;
    # neofetch;
    completionInit = "";
    initExtra = ''
      fpath=($HOME/.config/zshcompletions $fpath);
      autoload -U compinit && compinit;
      compdef nvidia-offload=exec;
      compdef runcage=exec;

      source ~/.config/p10k.zsh;
    '';
    envExtra = ''
      fpath=( ${pkgs.python311Packages.argcomplete}/lib/python3.11/site-packages/argcomplete/bash_completion.d "''${fpath[@]}" )
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

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      local config = wezterm.config_builder()
      config.enable_wayland = false
      config.color_scheme = "rose-pine-moon"
      config.front_end = "WebGpu"
      config.font_size = 24.0
      config.dpi = 384.0
      config.hide_tab_bar_if_only_one_tab = true
      config.font = wezterm.font "Mononoki Nerd Font Mono"
      return config
    '';
  };

  programs.tmux = {
  # https://gist.github.com/andersevenrud/015e61af2fd264371032763d4ed965b6
    enable = true;
    terminal = "alacritty";
    extraConfig = ''
set-option -sa terminal-features ',alacritty:RGB'
set-option -ga terminal-features ",alacritty:usstyle"
set-option -ga terminal-overrides ',alacritty:Tc'
    '';
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 3;
          y = 3;
        };
      };
      font = {
        normal = {
          family = "Mononoki Nerd Font Mono";
          style = "Regular";
        };
        size = 11;
        offset = {
          y = -1;
        };
      };
      debug = {
        persistent_logging = true;
        log_level = "Info";
      };
      general.import = [
        "${pkgs.alacritty-theme}/rose_pine_moon.toml"
      ];
    };
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
    # themeFile = "Rosé Pine Moon";
    shellIntegration.enableZshIntegration = true;
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "Mononoki Nerd Font Mono:size=11";
        # dpi-aware = "yes";
      };
    };
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
      push.autoSetupRemote = "true";
      safe.directory = "*";
    };
  };

  dconf.settings = {
    #"org/gnome/desktop/interface" = {
    #  color-scheme = "prefer-dark";
    #};
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
    # size = 36;
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
