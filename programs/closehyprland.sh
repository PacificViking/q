#!/usr/bin/env bash
outt=$(notify-send -A "default=close" "Close Hyprland?")
if [ "$outt" == "default" ]; then
    hyprctl dispatch exit
fi

