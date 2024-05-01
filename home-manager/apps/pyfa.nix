{ config, pkgs, ... }:
let
  pyfa = pkgs.appimageTools.wrapType2 rec {
    name = "pyfa";
    version = "2.57.3";
    src = pkgs.fetchurl {
      url = "https://github.com/pyfa-org/Pyfa/releases/download/v${version}/pyfa-v${version}-linux.AppImage";
      hash = "sha256-IS+yYYn+aRh8QxCMmlQjV1ysR1rSmPgRSa+2+gKtw5c=";
    };
    extraPkgs = pkgs: with pkgs; [
      libnotify
      pcre2
    ];
  };

in {
  home.packages = [
    pyfa
  ];
}
