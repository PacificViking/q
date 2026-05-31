{ config, lib, pkgs, modulesPath, inputs, settings, ... }:

{
  hardware.graphics = {
    enable = true;
    # driSupport = true;
    # driSupport32Bit = true;
    # package = pkgs-unstable.mesa.drivers;  # use Hyprland's mesa drivers
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      # vaapiIntelHybrid  # LIBVA_DRIVER_NAME=i965
      libva-vdpau-driver
      libvdpau-va-gl
      nvidia-vaapi-driver  # LIBVA_DRIVER_NAME=nvidia
    # ] ++ [
    #   pkgs-unstable.mesa.drivers  # use Hyprland's mesa drivers
    ];
  };
  # https://www.youtube.com/watch?v=61wGzIv12Ds
  # nvidia.modesetting.enable = true;
}
