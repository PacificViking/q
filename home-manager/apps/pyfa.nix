{ config, pkgs, ... }:
let
  pyfa = pkgs.appimageTools.wrapType2 rec {
    name = "pyfa";
    version = "2.58.2";
    src = pkgs.fetchurl {
      url = "https://github.com/pyfa-org/Pyfa/releases/download/v${version}/pyfa-v${version}-linux.AppImage";
      hash = "sha256-CSCKfNHuTfSfTibZFNbvyD3IUTJPm8pGqITD7peSrA8=";
    };
    extraPkgs = pkgs: with pkgs; [
      libnotify
      pcre2
    ];
  };

in {
  xdg.desktopEntries.pyfa = {
    name = "pyfa";
    genericName = "Python Fitting Assistant";
    exec = "pyfa";
    terminal = false;
    categories = [ "Engineering" ];
    startupNotify = true;
  };
  home.packages = [
    pyfa
  ];
}
