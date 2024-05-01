{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    masternixpkgs.url = "github:NixOS/nixpkgs/master";
    #localnixpkgs = nixpkgs;
    localnixpkgs = {
      type = "path";
      path = "/home/john/opensource/nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";

      # type = "path";
      # path = "/home/john/opensource/Hyprland";

      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
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
    ags = {
      url = "github:Aylur/ags/d1835cad79868cab3154d673e6d37b6b46624611";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, masternixpkgs, localnixpkgs, home-manager, hyprland, ...}@inputs:
  let
    pkgs = import nixpkgs { system = settings.systemtype; config.allowUnfree = true; config.cudaSupport = true;};

    masterpkgs = import masternixpkgs { system = settings.systemtype; config.allowUnfree = true; config.cudaSupport = true;};

    localpkgs = import localnixpkgs { system = settings.systemtype; config.allowUnfree = true; config.cudaSupport = true;};

    settings = {
      #set these settings for your system information
      hostname = "johnnixos";
      username = "john";
      confpath = "/home/john/q/";
      systemtype = "x86_64-linux";  # this doesn't change the system type in hardware-configuration
      hashedPassword = "$y$j9T$F6E.RndEt7cBNaGQWJtp41$A8VWWC4yzeJKCdimX4EhM7V8h0qbj0jfBme0QVEeTP5";
    };

  in {
    #separate nixosConfigurations and homeConfigurations to separate the flake.nixes
    nixosConfigurations."${settings.hostname}" = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      specialArgs = { inherit inputs settings localpkgs masterpkgs; };
      modules = [
        nixos/configuration.nix
        inputs.musnix.nixosModules.musnix
        inputs.nur.nixosModules.nur
      ];
    };


    homeConfigurations."${settings.username}@${settings.hostname}" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs settings localpkgs masterpkgs; };

      modules = [
        #hyprland.homeManagerModules.default
        #{wayland.windowManager.hyprland.enable = true;}
        home-manager/j.nix
        inputs.nur.nixosModules.nur
        # ...
      ];
    };

  };
}
