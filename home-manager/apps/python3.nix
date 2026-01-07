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
    seaborn
    matplotlib

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
    torchvision-bin
    opencv-python
    albumentations
    shapely
    faiss
    # open-clip-torch
    # keras
    scikit-learn
    scikit-image
    pymongo
    beautifulsoup4
    transformers

    imagehash
    networkx

    pwntools
  ];
in {
  home.packages = [
    (pkgs.python313.withPackages python-packages)
    pkgs.py-spy
    # pkgs.ruff
  ];
}
