{ config, lib, pkgs, modulesPath, inputs, settings, localpkgs, ... }:
{
  services.dbus.packages = [ pkgs.miraclecast ];
  environment.systemPackages = with pkgs; [
    iw
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi
  ] ++ [
    #pkgs.miraclecast
    localpkgs.miraclecast
  ];
}
