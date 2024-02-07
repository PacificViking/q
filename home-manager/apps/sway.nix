{ config, pkgs, settings, lib, ... }:
{
#  home.file = {
#    # You can also set the file content immediately.
#    ".config/sway/config".text = ''
#set $menu bemenu-run
#
## screenshots
#bindsym $mod+c exec grim  -g "$(slurp)" /tmp/$(date +'%H:%M:%S.png')
#
#
#exec dbus-sway-environment
#exec configure-gtk
#
## Brightness
#bindsym XF86MonBrightnessDown exec light -U 10
#bindsym XF86MonBrightnessUp exec light -A 10
#
## Volume
#bindsym XF86AudioRaiseVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'
#bindsym XF86AudioLowerVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'
#bindsym XF86AudioMute exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'
#    '';
#  };

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    config = rec {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "alacritty"; 
      keybindings = lib.mkOptionDefault {
        "${modifier}+x" = "exec firefox-nightly";
      };
      input = {
        "*" = {
          natural_scroll = "enabled";
        };
      };
      # waybar doesn't work with sway yet
      # bars = [];
      startup = [
      # {"command" = "waybar"; "always" = true;}
      ];
    };
    extraOptions = [
      "--unsupported-gpu"
    ];
    extraConfig = ''
set $lock 'swaylock -f --screenshots --effect-blur 10x10'
bindswitch --reload --locked lid:on exec $lock
    '';
  };
}
