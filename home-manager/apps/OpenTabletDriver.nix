{ config, lib, pkgs, inputs, settings, hardware, ... }:
{
  home.file = {
    ".config/OpenTabletDriver".source = config.lib.file.mkOutOfStoreSymlink "${settings.confpath}/home-manager/config/OpenTabletDriver";  # ./.. is one directory up
  };
}
