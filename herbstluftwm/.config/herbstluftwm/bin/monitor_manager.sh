#!/bin/bash

set -eo pipefail

FIRST_MONITOR="$(xrandr | sed -nr 's/(LVDS-*[0-9]).+/\1/p')"
SECOND_MONITOR="$(xrandr | sed -nr 's/((VGA-*[0-9])|(HDMI-*[0-9])) connected.+/\1/p')"

second_monitor_state() {
    xrandr | sed -nr "s/$SECOND_MONITOR (connected|disconnected) .+/\1/p"
}

hc() {
    herbstclient "$@"
}

up() {
    xrandr --auto
    xrandr --output "$SECOND_MONITOR" --above "$FIRST_MONITOR"
    hc pad 0 0
    hc pad 1 25
    hc emit_hook monitor_changed
}

down() {
    xrandr --auto
    xrandr --output "$SECOND_MONITOR" --below "$FIRST_MONITOR"
    hc pad 1 0
    hc pad 0 25
    hc emit_hook monitor_changed
}

right() {
    xrandr --auto
    xrandr --output "$SECOND_MONITOR" --right-of "$FIRST_MONITOR"
    hc pad 1 0
    hc pad 0 25
    hc emit_hook monitor_changed
}

left() {
    xrandr --auto
    xrandr --output "$SECOND_MONITOR" --left-of "$FIRST_MONITOR"
    hc pad 1 0
    hc pad 0 25
    hc emit_hook monitor_changed
}

single() {
    xrandr --auto
    xrandr --output "$SECOND_MONITOR" --off
    hc pad 0 25
    hc emit_hook monitor_changed
}

auto() {
    local MONITOR_CONNECTION_STATUS="$(second_monitor_state)"
    if [[ "$MONITOR_CONNECTION_STATUS" = "disconnect" ]] ; then
        single
    else
        left
    fi
}

case "$1" in
    up) up ;;
    down) down ;;
    right) right ;;
    left) left ;;
    single) single ;;
    *) auto;;
esac

killall polybar
polybar main &
nitrogen --restore
