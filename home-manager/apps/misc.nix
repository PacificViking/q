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
