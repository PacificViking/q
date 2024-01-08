{ config, pkgs, ... }:
let
  python-packages = ps: with ps; [
    pylint
    pynvim
    jedi

    numpy
    parse
    requests
  ];
in {
  home.packages = [
    (pkgs.python3.withPackages python-packages)
  ];
}
