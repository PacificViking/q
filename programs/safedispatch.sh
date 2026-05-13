#!/usr/bin/env bash
# only execute this if it's not eve online
title=$(hyprctl activewindow -j | jq -r '.title')
class=$(hyprctl activewindow -j | jq -r '.class')

if [[ "$class" == "steam_app_8500" && "$title" == EVE* && "$title" != "EVE Launcher"* ]]; then
    exit 0
fi

hyprctl dispatch "$@"
