#!/bin/bash

CARD="bluez_card.00_0A_45_31_57_76"

# Get current profile
CURRENT_PROFILE=$(pactl list cards | awk -v card="$CARD" '
  $0 ~ "Name: "card {found=1}
  found && /Active Profile:/ {print $NF; exit}
')

# Toggle logic
if [[ "$CURRENT_PROFILE" == "a2dp-sink" ]]; then
  pactl set-card-profile "$CARD" headset-head-unit
  notify-send -u normal "Bluetooth Profile" "Switched to HSP/HFP (Mic On)"
  echo "🎤 mic on"
else
  pactl set-card-profile "$CARD" a2dp-sink
  notify-send -u normal "Bluetooth Profile" "Switched to A2DP (Mic Off)"
  echo "🎧 mic off"
fi
