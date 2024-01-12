# fcitx5, shamelessly copying fcitx5-configtool configs
# these might even need to be cancelled when I need to use configtool again
{ config, pkgs, ... }:
{
  xdg.desktopEntries.pyfa = {
    name = "pyfa";
    genericName = "Python Fitting Assistant";
    exec = "pyfa";
    terminal = false;
    categories = [ ];
    startupNotify = true;
  };
  home.file = {
  };
  home.packages = [
  ];
}
