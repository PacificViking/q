{ config, lib, pkgs, modulesPath, inputs, settings, ... }:
{
  hardware.opentabletdriver = {
    enable = true;
    #daemon.enable = true;
  };
  # https://github.com/cidkidnix/nixcfg/blob/342d0ce35ed2e139e55f7fb1cee7bca2dd5337f9/machines/nixos-desktop/base.nix
  systemd.user.services.opentabletdriver.wantedBy = lib.mkForce [ "default.target" ];
  systemd.user.services.opentabletdriver.partOf = lib.mkForce [ "default.target" ];
  systemd.user.services.opentabletdriver.environment = {
    WAYLAND_DISPLAY = "wayland-1";
  };
  
  #systemd.user.services.opentabletdriver = lib.mkForce {
  #  enable = true;
  #  description = "Open source, cross-platform, user-mode tablet driver";
  #  #wantedBy = [ "graphical-session.target" ];
  #  partOf = [ "graphical-session.target" ];
  #  after = [ "graphical-session.target" ];
  #  #ConditionEnvironment 
  #
  #  serviceConfig = {
  #    #Type = "exec";
  #    ExecStart = "${pkgs.opentabletdriver}/bin/otd-daemon";
  #    Restart = "always";
  #    RestartSec = 3;
  #
  #    #RemainAfterExit = true;
  #  };
  #  
  #  Install = {
  #    WantedBy = [ "graphical-session.target" ];
  #  };
  #
  #};
}

