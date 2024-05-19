{ config, pkgs, ... }:
let
  python-packages = ps: with ps; [
    pylint
    pynvim
    jedi

    sympy
    numpy
    parse
    requests
    fabric  # ssh library

    pycuda
    # tensorflow
    # torch  # conflicts with tensorflow in many paths
    keras
    scikit-learn
  ];
in {
  home.packages = [
    (pkgs.python3.withPackages python-packages)
    pkgs.py-spy
    pkgs.ruff
  ];
}
