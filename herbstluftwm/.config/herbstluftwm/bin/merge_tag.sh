#!/bin/bash

toMerge=$(herbstclient attr tags.focus.name)

if [[ "$toMerge" -eq 1 || "$toMerge" -eq 2 ]] ; then
    exit
fi

herbstclient use_index -1 --skip-visible
herbstclient merge_tag "$toMerge"
