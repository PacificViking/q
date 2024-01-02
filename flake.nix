{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #localnixpkgs = nixpkgs;
    localnixpkgs = {
      type = "path";
      path = "/home/john/opensource/nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-firefox-nightly = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprprop-rust = {
      url = "github:PacificViking/hyprprop-rust";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xdg-desktop-portal-hyprland = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, localnixpkgs, home-manager, hyprland, ...}@inputs:
  let
    pkgs = import nixpkgs { system = settings.systemtype; config.allowUnfree = true; };

    localpkgs = import localnixpkgs { system = settings.systemtype; config.allowUnfree = true; };

    settings = {
      #set these settings for your system information
      hostname = "johnnixos";
      username = "john";
      confpath = "/home/john/q/";
      systemtype = "x86_64-linux";  # this doesn't change the system type in hardware-configuration
    };

  in {
    #separate nixosConfigurations and homeConfigurations to separate the flake.nixes
    nixosConfigurations."${settings.hostname}" = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      specialArgs = { inherit inputs settings localpkgs; };
      modules = [
        nixos/configuration.nix
        inputs.musnix.nixosModules.musnix
      ];
    };


    homeConfigurations."${settings.username}@${settings.hostname}" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs settings localpkgs; };

      modules = [
	#hyprland.homeManagerModules.default
	#{wayland.windowManager.hyprland.enable = true;}
	home-manager/j.nix
        # ...
      ];
    };

  };
}
