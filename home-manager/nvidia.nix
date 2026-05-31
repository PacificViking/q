{ config, pkgs, lib, inputs, settings, localpkgs, masterpkgs, ... }:
{
  home.packages = [
    pkgs.nvtopPackages.nvidia
  ];
}
