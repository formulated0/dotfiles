#!/bin/bash
# Launcher for networkmanager-dmenu

# Check if networkmanager_dmenu is available
if ! command -v networkmanager_dmenu &> /dev/null; then
    notify-send "Error" "networkmanager_dmenu not found in PATH"
    exit 1
fi

# --wifi: Only show WiFi options
# --compact: Remove separator lines from the output
networkmanager_dmenu --dmenu --wifi --compact -theme "$HOME/.config/rofi/iwmenu/style.rasi"