#!/bin/bash

FIRST_MONITOR="$(xrandr | sed -nr 's/(LVDS-*[0-9]).+/\1/p')"
SECOND_MONITOR="$(xrandr | sed -nr 's/(VGA-*[0-9]).+/\1/p')"

hc() {
    herbstclient "$@"
}

up() {
   xrandr --auto
   xrandr --output "$SECOND_MONITOR" --above $FIRST_MONITOR
   hc pad 0 0
   hc pad 1 25
   hc emit_hook monitor_changed
}

down() {
   xrandr --auto
   xrandr --output "$SECOND_MONITOR" --below $FIRST_MONITOR
   hc pad 1 0
   hc pad 0 25
   hc emit_hook monitor_changed
}

right() {
   xrandr --auto
   xrandr --output "$SECOND_MONITOR" --right-of $FIRST_MONITOR
   hc pad 1 0
   hc pad 0 25
   hc emit_hook monitor_changed
}

left() {
   xrandr --auto
   xrandr --output "$SECOND_MONITOR" --left-of $FIRST_MONITOR
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
   if [[ "disconnect" = "$(cat /sys/class/drm/card1-$SECOND_MONITOR/status)" ]] ; then
       single
   else
       right
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
