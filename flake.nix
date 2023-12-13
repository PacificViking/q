{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
  };
  outputs = { self, nixpkgs, home-manager, hyprland, ...}@inputs:
  let
    pkgs = import nixpkgs { system = settings.systemtype; config.allowUnfree = true; };
    settings = {
      #set these settings for your system information
      hostname = "johnnixos";
      username = "john";
      confpath = "/home/john/q/";
      systemtype = "x86_64-linux";
    };

  in {
    #separate nixosConfigurations and homeConfigurations to separate the flake.nixes
    nixosConfigurations.johnnixos = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      specialArgs = { inherit inputs settings; };
      modules = [ nixos/configuration.nix ];
    };


    homeConfigurations."${settings.username}@${settings.hostname}" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs settings; };

      modules = [
	#hyprland.homeManagerModules.default
	#{wayland.windowManager.hyprland.enable = true;}
	home-manager/j.nix
        # ...
      ];
    };

  };
}
