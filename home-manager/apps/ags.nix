{ config, pkgs, inputs, settings, ... }:
let
#agsconfig = pkgs.fetchFromGitHub {
#  owner = "Aylur";
#  repo = "ags";
#  rev = "f681ba237a09bb0ad0c27d8792badcb4a4116e7a";
#  hash = "sha256-gAPKQ24+CWBZVvZaq166Y5JUgJaxLtPyH42mV29/MK4=";
#};
agsconfig = pkgs.fetchFromGitHub {
  owner = "Aylur";
  repo = "dotfiles";
  rev = "668f8bd87d88ae249cb6e20892f956e3d74dabe2";
  hash = "sha256-L+AP/npoVqIrFPSDY38hm8bt+tooAYU5AYOhMw26cnY=";
};
#agsconfig = pkgs.fetchFromGitHub {
#  owner = "end-4";
#  repo = "dots-hyprland";
#  rev = "1dafc61b7dfe2eab4eed102c879c9e37cb11062f";
#  hash = "sha256-j8ydMT02KmGB6nqO7SMHT4tCA8dC26QqK9T/z3TQnvg=";
#};
ppkgs = import inputs.ags.inputs.nixpkgs { system = settings.systemtype; };
in
{
  imports = [ inputs.ags.homeManagerModules.default ];

  home.file = {
    ".config/ags".source = config.lib.file.mkOutOfStoreSymlink "${settings.confpath}/home-manager/config/ags";  # ./.. is one directory up
  };

  programs.ags = {
    enable = true;
    #configDir = "${agsconfig.outPath}/example/media-widget";
    #configDir = "${agsconfig.outPath}/ags";
    extraPackages = [
      ppkgs.gtksourceview
      ppkgs.sassc
      ppkgs.glibc
      # ppkgs.fcitx5-with-addons
    ];
  };
  home.packages = [
    pkgs.ydotool
    pkgs.gtksourceview
    pkgs.sassc
    pkgs.brightnessctl
    pkgs.glibc
  ];
}
