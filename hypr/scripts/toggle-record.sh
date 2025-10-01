#!/bin/bash

output_dir="$HOME/Videos/Screencasts"
mkdir -p "$output_dir"
pidfile="/tmp/wf-recorder.pid"

# If wf-recorder is running, stop it
if [ -f "$pidfile" ] && kill -0 "$(cat "$pidfile")" 2>/dev/null; then
    pid=$(cat "$pidfile")
    rm -f "$pidfile"
    kill -INT "$pid"

    # Find the most recent .mp4 file
    latest_file=$(ls -t "$output_dir"/*.mp4 2>/dev/null | head -n 1)

    if [ -n "$latest_file" ]; then
        notify-send -a wf-recorder "Recording stopped" "Saved to:\n$latest_file"
    else
        notify-send -a wf-recorder "Recording stopped" "File not found."
    fi

    exit 0
fi

# Start new recording
region=$(slurp) || exit 1
sleep 0.25  # Wait for window close animation

filename="recording_$(date +%Y-%m-%d_%H%M%S).mp4"
outfile="$output_dir/$filename"

notify-send -a wf-recorder "Recording started" "Saving to:\n$outfile"

wf-recorder -g "$region" -f "$outfile" &
echo $! > "$pidfile"
