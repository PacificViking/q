{ config, lib, pkgs, modulesPath, inputs, settings, ... }:
{
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };
}

