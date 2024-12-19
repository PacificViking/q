{ config, pkgs, ... }:
let
  polkit_gnome_everywhere = pkgs.polkit_gnome.overrideAttrs (old: {
    name = "polkit-gnome-everywhere";
    postInstall = ''
      mkdir -p $out/etc/xdg/autostart;
      substituteAll ${./polkit-gnome-authentication-agent-1.desktop} $out/etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop;
    '';
    # this is ugly: I am using the local desktop file because polkit-gnome-original doesnt refer to itself
      # sed -i 's/OnlyShowIn=GNOME;XFCE;Unity;//g' $out/etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop;
  });
in {
  environment.systemPackages = [
    polkit_gnome_everywhere
  ];
}
