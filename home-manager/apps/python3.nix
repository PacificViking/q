{ config, pkgs, ... }:
let
  python-packages = ps: with ps; [
    pylint
    pynvim
    jedi
    ruff-lsp

    sympy
    numpy
    tqdm

    parse
    requests
    fabric  # ssh library

    libclang

    pycuda
    # tensorflow
    # torch  # conflicts with tensorflow in many paths
    keras
    scikit-learn
    pymongo
  ];
in {
  home.packages = [
    (pkgs.python3.withPackages python-packages)
    pkgs.py-spy
    pkgs.ruff
  ];
}
