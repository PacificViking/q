#!/usr/bin/env zsh

# tries to copy the selected portion, then notifies

slurppos=$(slurp); slurpexit=$?; if [[ $slurpexit -eq 0 ]]; then grim -g $slurppos - | wl-copy -t image/png; notify-send "Image Copied" --expire-time 1500; fi;
