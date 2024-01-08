{ config, pkgs, inputs, ... }:
{
  imports = [ inputs.ags.homeManagerModules.default ];
  programs.ags = {
    enable = true;
    configDir = ./config/ags;  # no need for symlink
    extraPackages = [];
  };
}
