#!/bin/bash

set -eo pipefail

MUTED_STATUS="$(amixer sget Master | sed -nr 's/.*Mono: Playback .* \[(on|off).*/\1/p')"
CURRENT_VOLUME="$(amixer sget Master | sed -nr 's/.*Mono: Playback [0-9]{1,2} \[([0-9]{1,3}\%).*/\1/p')"

if [ "$MUTED_STATUS" == "off" ]; then
    volnoti-show --mute
else
    volnoti-show "$CURRENT_VOLUME"
fi
