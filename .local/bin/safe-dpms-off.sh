#!/bin/bash

players=$(playerctl -l 2>/dev/null | grep -vE 'vesktop|discord')

for p in $players; do
    status=$(playerctl -p "$p" status 2>/dev/null)
    if [[ "$status" == "Playing" ]]; then
        exit 0  # Media is playing, don't turn off screen
    fi
done

hyprctl dispatch dpms off
