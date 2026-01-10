# fcitx5, shamelessly copying fcitx5-configtool configs
# these might even need to be cancelled when I need to use configtool again
{ config, pkgs, ... }:
{
  home.file = {
    ".config/fcitx5" = {
      source = ../config/fcitx5;
      #recursive = true;
    };
    ".config/fcitx" = {
      source = ../config/fcitx;
      #recursive = true;
    };
  };
  home.packages = [
  ];
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
      fcitx5-nord
      qt6Packages.fcitx5-chinese-addons
    ];
  };
}
