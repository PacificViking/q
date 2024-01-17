{ config, pkgs, ... }:
let
  wltoxclip-watch = pkgs.writeTextFile {
    name = "wltoxclip-watch";
    destination = "/bin/wltoxclip-watch";
    executable = true;
    # https://forum.winehq.org/viewtopic.php?t=38026
    text = ''
    wl-paste -t text -w ${pkgs.xclip}/bin/xclip -selection clipboard
    ''; # uses real xclip package to copy to x, uses wl-clipboard-x11 package for x apps to use to copy to wayland
    # yay nix!!!
  };
in
{
  home.file = {
  };
  home.packages = [
    wltoxclip-watch
  ];
}
