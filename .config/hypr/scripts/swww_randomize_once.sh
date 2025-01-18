#!/bin/bash

# This script will randomly select a file from a directory and set it
# up as the wallpaper.

if [[ $# -lt 1 ]] || [[ ! -d $1 ]]; then
    echo "Usage:
    $0 <dir containing images>"
    exit 1
fi

# Edit below to control the images transition
export SWWW_TRANSITION_FPS=60

# Select a random image from the specified directory
img=$(find "$1" -type f | shuf -n 1)

# Set the selected image as the wallpaper using swww
swww img "$img" --transition-type wipe --transition-duration 1.5
