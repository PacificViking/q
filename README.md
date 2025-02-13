## Steps For Reproduction
copy hardware-configuration.nix generated by nixos-generate-config (and replace my hardware-configuration.nix) because it contains information about mount points

nix run home-manager/master -- init --switch --flake ~/q
install home-manager and point to the flake in this very directory (this flake serves both nixos's configuration and home manager's)
you would probably have to rm .config/hypr beforehand

To reproduce:
In flake.nix:
set localnixpkgs to nixpkgs (to avoid using nonexistent local packages)
change hostname, where the directory would be placed etc >> let settings = {}

## Inspirations
- some configs inspired from https://github.com/XNM1/linux-nixos-hyprland-config-dotfile
- nvim transition to lua read from https://github.com/LunarVim/Neovim-from-scratch/tree/master
- ags config tried to take from https://github.com/end-4/dots-hyprland/tree/illogical-impulse

## Extra Configurations Needed
fcitx5-configtool to configure mozc and pinyin is required
you'll also need to configure Thunar yourself
And home-manager/config/gtk3.0 has my own locations, which may need changing
qt5ct has to be run to configure: config files have permanant links
kvantummanager has to be run to select qt5 theme
vscode and vscodium's window -> title bar style needs to be set to custom, or else it crashes (needs NIXOS_OZONE_WL set to 0 to use xwayland to actually start the program)

### Possible Extra Configurations
- python uses packages (torch, pycuda, tensorflow) that has dependency cuda, so cuda-toolkit might be needed

## Local Changes
(also pyfa)
ripgrep localpkgs and localnixpkgs

## TODO
- Refractor neovim plugin placement
- Separate my-filesystem-specific stuff like localnixpkgs
- - Provide separate flake config for other users
- Backup /q/ and .mozilla
- Pick and choose latex libraries: they're very large
- Fix "Running stop job for Session 3 of user (username)"
- Fix Thunar not opening windows partition
- - [https://www.reddit.com/r/xfce/comments/17n2v5p/mounting_a_ntfs_partition_with_thunar_xubuntu_2310/]
- - [https://github.com/NixOS/nixpkgs/issues/243234]
- fix fpath issue when `nix develop` (asks for file that cannot be accessed)
- Fix firefox + paxmod tab reordering (used to work)
- discord dilemma
- - Discord with --disable-gpu and wayland can't screenshare or push to talk
- - Discord using xwayland can't be dragged/copy pasted into and can't screenshare (and push to talk doesn't work with backtick)
- - Vesktop can't push to talk (but can screenshare)
