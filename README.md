copy hardware-configuration.nix generated by nixos-generate-config (and replace my hardware-configuration.nix) because it contains information about mount points

nix run home-manager/master -- init --switch --flake ~/q
install home-manager and point to the flake in this very directory (this flake serves both nixos's configuration and home manager's)
you would probabl have to rm .config/hypr beforehand

some configs inspired from https://github.com/XNM1/linux-nixos-hyprland-config-dotfile

fcitx5-configtool to configure mozc and pinyin is required
(or you can use my configurations, which are already symlinked)

I installed hyprprop using nix-env because it's not replicable

qt5ct has to be run to configure: config files have permanant links
kvantummanager has to be run to select qt5 theme

To reproduce:
In flake.nix:
set localnixpkgs to nixpkgs (to avoid using nonexistent local packages)
change hostname, where the directory would be placed etc >> let settings = {}
