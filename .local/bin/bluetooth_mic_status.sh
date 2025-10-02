#!/bin/bash

CARD="bluez_card.00_0A_45_31_57_76"

PROFILE=$(pactl list cards | awk -v card="$CARD" '
  $0 ~ "Name: "card {found=1}
  found && /Active Profile:/ {print $NF; exit}
')

if [[ "$PROFILE" == "a2dp-sink" ]]; then
  echo "🎧 mic off"
else
  echo "🎤 mic on"
fi
