#!/bin/bash

set -eo pipefail

NITROGEN_CFG="$HOME/.config/nitrogen/bg-saved.cfg"
WALLPAPER_IMAGE="$(sed -nr 's/file=(.+)/\1/p' "$NITROGEN_CFG" | head -n 1)"
WALLPAPER_FOLDER="$(dirname "$WALLPAPER_IMAGE")"

IMAGE_EXT="$(echo "${WALLPAPER_IMAGE##*.}" | tr '[:upper:]' '[:lower:]')"
if [ "$IMAGE_EXT" != "png" ]; then
    WALLPAPER_IMAGE=$(shuf -n 1 -e "$WALLPAPER_FOLDER"/*.{png,PNG})
fi

i3lock -i "$WALLPAPER_IMAGE"
