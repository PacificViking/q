{ config, pkgs, nixpkgs, home-manager, ... }:
let
  nix1903 = import <19.03> {};
  nix2305 = import <23.05> {};
  unstable = import <unstable> {};
in {
  nixpkgs.config.allowUnfree = true;

  environment.pathsToLink = [ "/share/zsh" ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
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
    kitty
    greetd.tuigreet
    zsh

    pipewire
  ];
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  services.pipewire = {
    enable = false;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.john.shell = pkgs.zsh;
}
