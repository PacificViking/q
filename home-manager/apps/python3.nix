{ config, pkgs, ... }:
let
  python-packages = ps: with ps; [
    pynvim
    numpy
    parse
  ];
in {
  home.packages = [
    (pkgs.python3.withPackages python-packages)
  ];
}
