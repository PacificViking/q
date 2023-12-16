{ config, lib, pkgs, inputs, settings, hardware, ... }:
{
  home.file = {
    ".config/OpenTabletDriver".source = config.lib.file.mkOutOfStoreSymlink "${builtins.toString ./.}/config/OpenTabletDriver";
  };
}
