{ config, lib, pkgs, modulesPath, inputs, settings, ... }:
{
  services.mysql = {
    enable = true;
    #package = mariadb_110;
    package = pkgs.mysql80;
    ensureUsers = [
      {
        name = settings.username;
        ensurePermissions = {
          "*.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  # disable autostart
  systemd.services.mysql.wantedBy = lib.mkForce [ ];
}
