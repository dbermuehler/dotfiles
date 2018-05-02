#!/bin/bash

set -eo pipefail

TAG_TO_MERGE=$(herbstclient attr tags.focus.name)

if [[ "$TAG_TO_MERGE" -eq "1" || "$TAG_TO_MERGE" -eq "2" ]] ; then
    exit
fi

herbstclient use_index -1 --skip-visible
herbstclient merge_tag "$TAG_TO_MERGE"
