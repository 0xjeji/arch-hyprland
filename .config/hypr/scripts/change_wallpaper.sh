#!/bin/bash

# This script will randomly select a file from a directory and set it
# up as the wallpaper. It will also change colors using pywal

if [[ $# -lt 1 ]] || [[ ! -d $1 ]]; then
  echo "Usage:
    $0 <dir containing images>"
  exit 1
fi

# Edit below to control the images transition and the history size
export SWWW_TRANSITION_FPS=60
HISTORY_SIZE=9
HISTORY_FILE="$HOME/.wallpaper_history"

# Ensure the history file exists
touch "$HISTORY_FILE"

# Function to select a random image that hasn't been used recently
select_random_image() {
  local img
  local recent_images
  recent_images=$(tail -n $HISTORY_SIZE "$HISTORY_FILE")

  while true; do
    img=$(find "$1" -type f | shuf -n 1)
    if ! grep -q "$img" <<<"$recent_images"; then
      echo "$img"
      break
    fi
  done
}

# Select a random image from the specified directory
img=$(select_random_image "$1")

# Set the selected image as the wallpaper using swww
swww img "$img" --transition-type wipe
sleep 2.5
wal -i "$img"

# Update waybar
killall waybar
waybar &

# Update the history file
echo "$img" >>"$HISTORY_FILE"

# Trim the history file to the specified size
tail -n $HISTORY_SIZE "$HISTORY_FILE" >"$HISTORY_FILE.tmp" && mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
