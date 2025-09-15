{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    masternixpkgs.url = "github:NixOS/nixpkgs/master";

    # copyparty.url = "github:9001/copyparty";
    copyparty = {
      type = "path";
      path = "/home/john/opensource/copyparty";
    };

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
    # hyprland = {
      # type = "path";
      # path = "/home/john/opensource/Hyprland";
      # inputs.nixpkgs.follows = "nixpkgs";
      # url = "git+file:///home/john/opensource/Hyprland?submodules=1";
    # };
    hyprland = {
      type = "github";
      owner = "hyprwm";
      repo = "Hyprland";

      # url = "github:hyprwm/Hyprland?submodules=1?ref=788ae588979c2a1ff8a660f16e3c502ef5796755";

      # ref = "fe7b748eb668136dd0558b7c8279bfcd7ab4d759";  # 0.39
      # ref = "cba1ade848feac44b2eda677503900639581c3f4";  # 0.40
      # ref = "9a09eac79b85c846e3a865a9078a3f8ff65a9259";  # 0.42
      # ref = "0c7a7e2d569eeed9d6025f3eef4ea0690d90845d";  # 0.44
      # ref = "a425fbebe4cf4238e48a42f724ef2208959d66cf";  # 0.45
      # ref = "788ae588979c2a1ff8a660f16e3c502ef5796755";  # 0.46
      # ref = "04ac46c54357278fc68f0a95d26347ea0db99496";  # 0.47
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    swww = {
      url = "github:LGFae/swww";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-firefox-nightly = {
      type = "github";
      owner = "nix-community";
      repo = "flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    betterfox = {
      type = "github";
      owner = "HeitorAugustoLN";
      repo = "betterfox-nix";
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
    # xdg-desktop-portal-hyprland = {
    #   url = "github:hyprwm/xdg-desktop-portal-hyprland";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # ags = {
    #   url = "github:Aylur/ags/d1835cad79868cab3154d673e6d37b6b46624611";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    ignis = {
      # url = "github:linkfrg/ignis";
      type = "path";
      path = "/home/john/opensource/ignis";

      inputs.nixpkgs.follows = "nixpkgs";
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
        inputs.nur.modules.nixos.default
        inputs.copyparty.nixosModules.default
      ];
    };


    homeConfigurations."${settings.username}@${settings.hostname}" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs settings localpkgs masterpkgs; };

      modules = [
        #hyprland.homeManagerModules.default
        #{wayland.windowManager.hyprland.enable = true;}
        home-manager/j.nix
        # ...
      ];
    };

  };
}
