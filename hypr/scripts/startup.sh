#!/bin/bash
# filepath: /home/formulated/.config/hypr/scripts/hyprland_startup.sh

# Launch Spotify on workspace 2
hyprctl dispatch exec "[workspace 2 silent] spotify-launcher"
while ! hyprctl clients | grep -q "class: Spotify"; do sleep 0.1; done

# Launch Cava on workspace 2
hyprctl dispatch exec "[workspace 2 silent] kitty -e cava"
while ! hyprctl clients | grep -q "cava"; do sleep 0.1; done

# Focus Cava, toggle split, set split ratio
hyprctl dispatch focuswindow title:cava
hyprctl dispatch togglesplit
hyprctl dispatch splitratio 0.60

# Launch Steam on workspace 5
hyprctl dispatch exec "[workspace 1 silent] steam -silent"

# Switch to workspace 3 and launch Discord
hyprctl dispatch workspace 3
sleep 1
vesktop &

#switch to workspace 1 after because steam opens on 5 and then it makes the default 5 so just go back to 1
sleep 5
hyprctl dispatch workspace 1


exit 0