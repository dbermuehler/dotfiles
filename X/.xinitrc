#!/bin/bash

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for file in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$file" ] && . "$file"
    done
    unset file
fi

xrdb -merge ~/.Xresources
xrdb -merge ~/.Xresources.local

xset r rate 200 30
synclient PalmDetect=1
synclient PalmMinWidth=8

xbindkeys &
volnoti &

if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval $(ssh-agent)
fi

# autocutsel -fork
# autocutsel -selection PRIMARY -fork

exec herbstluftwm
