{ config, pkgs, ... }:
let
  nvidiaElement = pkgs.element-desktop-wayland.overrideAttrs (old: {
    name = "nvidiaElement";
    postInstall = ''
sed -i '2 i\export __NV_PRIME_RENDER_OFFLOAD=1\nexport __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0\nexport __GLX_VENDOR_LIBRARY_NAME=nvidia\nexport __VK_LAYER_NV_optimus=NVIDIA_only' $out/bin/element-desktop
    '';
  });
in {
  xdg.desktopEntries.element = {
    name = "Element";
    genericName = "A sovereign and secure communications platform.";
    exec = "element-desktop";
    terminal = false;
    categories = [ "InstantMessaging" "Chat" "Network" "P2P" ];
    startupNotify = true;
  };
  home.packages = [
    nvidiaElement
  ];
}
