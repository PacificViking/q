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

    flask 
    python-jose

    parse
    requests
    fabric  # ssh library

    libclang

    pycuda
    # tensorflow
    # torch # conflicts with tensorflow in many paths
    # keras
    scikit-learn
    pymongo
  ];
in {
  home.packages = [
    (pkgs.python311.withPackages python-packages)
    pkgs.py-spy
    pkgs.ruff
  ];
}
