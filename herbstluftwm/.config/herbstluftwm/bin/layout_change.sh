#!/bin/bash

hc=herbstclient

case "$(echo -e "grid\nmax\nvertical\nhorizontal" | dmenu -i -p "Layout" -h 23)" in
    vertical)   $hc set_layout vertical ;;
    horizontal) $hc set_layout horizontal ;;
    max)        $hc set_layout max ;;
    grid)       $hc set_layout grid ;;
esac
