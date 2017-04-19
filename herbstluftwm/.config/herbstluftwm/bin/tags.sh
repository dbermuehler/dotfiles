#!/bin/bash

viewed_fg="#000000"
viewed_bg="#FFFFFF"
viewed_other_monitor_fg="#000000"
viewed_other_monitor_bg="#BDBDBD"
urgent_fg=
urgent_bg="#df8787"
used_fg="#FFFFFF"
used_bg=

dzenpar="-fn 'xft:ProFont:pixelsize=11' -ta l -w 200 -h 23"

herbstclient --idle 2>/dev/null | {
    tags=( $(herbstclient tag_status) )
    while true; do
        for tag in "${tags[@]}" ; do
            case ${tag:0:1} in
                '#') cstart="^fg($viewed_fg)^bg($viewed_bg)" ;;
                '%') cstart="^fg($viewed_fg)^bg($viewed_bg)" ;;
                '+') cstart="^fg($viewed_other_monitor_fg)^bg($viewed_other_monitor_bg)" ;;
                '-') cstart="^fg($viewed_other_monitor_fg)^bg($viewed_other_monitor_bg)" ;;
                ':') cstart="^fg($used_fg)^bg($used_bg)"     ;;
                '!') cstart="^fg($urgent_fg)^bg($urgent_bg)" ;;
                *)   cstart=''                               ;;
            esac
            dzenstring="${cstart}"
            dzenstring+="^ca(1,herbstclient focus_monitor 0 ; herbstclient use ${tag:1})"
            dzenstring+="^ca(2,[ "$(herbstclient attr tags.focus.name)" = "$(echo ${tag:1})" ] && herbstclient use_index -1 --skip-visible ; herbstclient merge_tag $(echo ${tag:1}))"
            dzenstring+="^ca(3,herbstclient move $(echo ${tag:1}))"
            dzenstring+="^ca(4,herbstclient focus_monitor 0 ; herbstclient use_index -1 --skip-visible)"
            dzenstring+="^ca(5,herbstclient focus_monitor 0 ; herbstclient use_index +1 --skip-visible)"
            dzenstring+=" ${tag:1} "
            dzenstring+="^ca()^ca()^ca()^ca()^ca()"
            dzenstring+="^fg()^bg()"
            echo -n "$dzenstring"
        done
        echo
        read hook || exit
        case "$hook" in
            tag*) tags=( $(herbstclient tag_status) ) ;;
            monitor_changed) tags=( $(herbstclient tag_status) ) ;;
            quit_panel*) exit ;;
        esac
    done
} | dzen2 $dzenpar
