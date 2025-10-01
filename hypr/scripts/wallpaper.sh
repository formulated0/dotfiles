#!/bin/bash

# A wallpaper switcher script using swww

# --- Configuration ---
WALLDIR="$HOME/.config/hypr/wallpapers"

# --- Script Logic ---

# Check if the wallpaper directory exists
if [ ! -d "$WALLDIR" ]; then
  notify-send "Error" "Wallpaper directory not found: $WALLDIR"
  exit 1
fi

# Select a new wallpaper using Rofi
SELECTED_WALL_NAME=$(find "$WALLDIR" -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif \) -printf "%f\n" | rofi -dmenu -theme "$HOME/.config/hypr/themes/wallpaper.rasi" -p "󰸉 Select Wallpaper")

# Exit if the user cancelled Rofi
if [ -z "$SELECTED_WALL_NAME" ]; then
    exit 0
fi

# Construct the full path to the selected wallpaper
SELECTED_WALL_PATH="$WALLDIR/$SELECTED_WALL_NAME"

# Set the new wallpaper with a smooth transition
swww img "$SELECTED_WALL_PATH" \
    --transition-type="any" \
    --transition-fps=60 \
    --transition-step=2

notify-send "Wallpaper Changed" "Set to: $SELECTED_WALL_NAME"