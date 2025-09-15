{ config, pkgs, ... }:
let
  python-packages = ps: with ps; [
    pylint
    pynvim
    jedi
    # ruff-lsp
    ruff

    sympy
    numpy
    pandas
    tqdm
    argcomplete
    pycrypto
    simpleaudio
    pyarrow
    openpyxl

    scapy
    levenshtein
    flask 
    python-jose

    parse
    requests
    fabric  # ssh library
    pexpect

    libclang

    pycuda
    # tensorflow
    # torch # conflicts with tensorflow in many paths
    torch-bin
    # keras
    scikit-learn
    pymongo
  ];
in {
  home.packages = [
    (pkgs.python311.withPackages python-packages)
    pkgs.py-spy
    # pkgs.ruff
  ];
}
