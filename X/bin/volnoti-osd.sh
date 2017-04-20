#!/bin/bash

if [ "$(amixer sget Master | sed -nr 's/.*Mono: Playback .* \[(on|off).*/\1/p')" == "off" ]; then
    volnoti-show --mute
else
    volnoti-show "$(amixer sget Master | sed -nr 's/.*Mono: Playback [0-9]{1,2} \[([0-9]{1,3}\%).*/\1/p')"
fi
