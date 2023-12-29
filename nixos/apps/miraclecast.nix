{ config, lib, pkgs, modulesPath, inputs, settings, ... }:
{
  services.dbus.packages = [ pkgs.miraclecast ];
  environment.systemPackages = with pkgs; [
    iw
    miraclecast
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi
  ];
}
