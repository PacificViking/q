{ config, pkgs, ... }:
{
  imports = [
    apps/waybar.nix
  ];
  
  home.username = "john";
  home.homeDirectory = "/home/john";

  home.stateVersion = "23.05"; # don't change

  home.packages = [
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs.dolphin
    pkgs.nerdfonts
    pkgs.git
    pkgs.nodejs
    pkgs.firefox-devedition
    pkgs.wofi
    pkgs.wl-clipboard

    pkgs.findutils
    pkgs.ripgrep

    pkgs.xfce.thunar
    pkgs.xfce.xfce4-icon-theme
    pkgs.xfce.thunar-volman
    pkgs.gvfs
    pkgs.polkit_gnome
    
    pkgs.neofetch
    pkgs.catppuccin-kde
    pkgs.font-awesome

    pkgs.networkmanagerapplet
    pkgs.bluez
    pkgs.bluez-tools

    pkgs.xorg.setxkbmap
    pkgs.xkb-switch
    pkgs.xkblayout-state
  ];

  home.file = {
    ".config/waybar" = {
      source = ./config/waybar;
      recursive = true;
    };
    ".config/hypr" = {
      source = ./config/hypr;
      recursive = true;
    };
    ".config/p10k.zsh" = {
      source = ./config/p10k.zsh;
    };
    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  xsession = {
    enable = true;
    windowManager.command = "emacs";
  };

  programs.zsh = {
    shellAliases = {  # shellGlobalAliases for replace anywhere
      "j_listInputs" = "sudo libinput list-devices";
      "j_listHyprDevices" = "hyprctl devices";
      "j_nixSearch" = "nix-env -qa";
      "j_manNix" = "man configuration.nix";
      "j_manHNix" = "man home-configuration.nix";
      "j_gitDiff" = "git diff HEAD";
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
    font = {
      name = "Mononoki Nerd Font Mono";
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
    };
  };

  services.blueman-applet = {
    enable = true;
  };
  services.network-manager-applet.enable = true;


  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 36;
  };

  gtk = {
    enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
