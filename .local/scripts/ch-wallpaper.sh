#!/bin/bash

set -e

notify() {
	notify-send "Failed to change wallpaper";
}

WALLPAPER_PATH="$HOME/.local/wallpapers"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"
LAST_WALLPAPER_FILE="$CACHE_DIR/last_wallpaper.txt"

mkdir -p "$CACHE_DIR"

# Get a list of wallpapers, excluding the last one
if [[ -f "$LAST_WALLPAPER_FILE" ]]; then
	LAST_WALLPAPER=$(<"$LAST_WALLPAPER_FILE")
	# Use grep -v to exclude last wallpaper
	MATCHING_WALLPAPERS=$(ls "$WALLPAPER_PATH" | grep -v -F "$LAST_WALLPAPER")
else
	MATCHING_WALLPAPERS=$(ls "$WALLPAPER_PATH")
fi

# If all wallpapers are excluded (i.e., only one exists), fallback
if [[ -z "$MATCHING_WALLPAPERS" ]]; then
	MATCHING_WALLPAPERS=$(ls "$WALLPAPER_PATH")
fi

WALLPAPER_NAME=$(echo "$MATCHING_WALLPAPERS" | shuf -n 1)

# Save the new wallpaper name
echo "$WALLPAPER_NAME" > "$LAST_WALLPAPER_FILE"

# Notify and set wallpaper
# hyprctl notify -1 2000 "rgb(ffffff)" "fontsize:14 $WALLPAPER_NAME" >> /dev/null

awww img "$WALLPAPER_PATH/$WALLPAPER_NAME" \
	--transition-type=simple \
	--transition-step=25 \
	--transition-fps=30 || {
		notify;
		exit 1;
	}
