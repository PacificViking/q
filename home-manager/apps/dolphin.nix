{ config, pkgs, ... }:
let
  dolphinNoDbus = pkgs.kdePackages.dolphin.overrideAttrs (old: {
    name = "dolphinNoDbus";
    postInstall = ''
      sed -i 's/org.freedesktop.FileManager1/org.freedesktop.FileManager1.dolphin/g' $out/share/dbus-1/services/org.kde.dolphin.FileManager1.service
    '';
  });
in {
  home.packages = [
    dolphinNoDbus
  ];
}
