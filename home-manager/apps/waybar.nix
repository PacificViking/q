{ config, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
  };
  home.packages = [
    # pkgs.pavucontrol
    pkgs.lxqt.pavucontrol-qt
    pkgs.gtk3.dev
    pkgs.gobject-introspection.dev
    pkgs.libpulseaudio
    pkgs.libnl
    pkgs.libappindicator-gtk3
    pkgs.libdbusmenu-gtk3
    pkgs.libmpdclient
    pkgs.sndio
    pkgs.libevdev
  ];
}
