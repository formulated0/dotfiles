#!/bin/bash

# List all media players that are playing, except vesktop/discord
players=$(playerctl -l 2>/dev/null | grep -vE 'vesktop|discord')

for p in $players; do
    status=$(playerctl -p "$p" status 2>/dev/null)
    if [[ "$status" == "Playing" ]]; then
        exit 0  # Media is playing, don't lock
    fi
done

# If no media is playing, run hyprlock
hyprlock
