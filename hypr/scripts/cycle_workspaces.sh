#!/usr/bin/env bash

# Get active monitor name
monitor=$(hyprctl activeworkspace -j | jq -r '.monitor')

# Get current workspace ID
current_ws=$(hyprctl activeworkspace -j | jq -r '.id')

# Get list of workspace IDs on this monitor
ws_list=$(hyprctl workspaces -j | jq -r --arg mon "$monitor" '.[] | select(.monitor == $mon) | .id' | sort -n)

# Convert to array
readarray -t ws_array <<< "$ws_list"

# Find current index
for i in "${!ws_array[@]}"; do
    if [[ "${ws_array[$i]}" == "$current_ws" ]]; then
        current_index=$i
        break
    fi
done

# Calculate next index (with wrap-around)
next_index=$(( (current_index + 1) % ${#ws_array[@]} ))
next_ws=${ws_array[$next_index]}

# Switch to next workspace
hyprctl dispatch workspace "$next_ws"
