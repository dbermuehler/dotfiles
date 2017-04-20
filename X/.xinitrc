#!/bin/bash

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

xrdb -merge ~/.Xresources
xrdb -merge ~/.Xresources.local

xset r rate 200 30

xbindkeys &
volnoti &

if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval $(ssh-agent -t 7200)
fi

# autocutsel -fork
# autocutsel -selection PRIMARY -fork

exec herbstluftwm
