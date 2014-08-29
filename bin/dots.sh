#!/bin/bash

unset DOTFILES
unset DOTFOLDER

declare -A DOTFILES

printerr() {
    tput setaf 1
    echo "ERROR:$(tput sgr0) $@"
}

overrideQuestion() {
    unset OVERRIDE

    read -e -n 1 -p "${@:-Override it? (y/n): }" OVERRIDE
    while [[ ("$OVERRIDE" != "y") && ("$OVERRIDE" != "n") ]] ; do
        printerr "Not a correct option please chose again!"
        read -e -n 1 -p "${@:-Override it? (y/n): }" OVERRIDE
    done
}

if [[ ! -f "$1" ]]; then
    printerr "Please add an vaild install file as an argument."
    exit 1
fi

. $1

for link in "${!DOTFILES[@]}"; do
    if [[ -e "${DOTFILES["$link"]}" ]] ; then
        if [[ -L $link ]]; then
            if [[ ! ($link -ef ${DOTFILES["$link"]}) ]]; then
                printerr "Symlink $link already exist and pointing at $(readlink $link)."
                overrideQuestion
                if [[ "$OVERRIDE" = "y" ]] ; then
                    rm $link
                    ln -s ${DOTFILES["$link"]} $link
                fi
            fi
        else
            if [[ -f $link ]]; then
                 printerr "$link is not a symlink but a normal file."
                 overrideQuestion "Override it with symlink to ${DOTFILES["$link"]} ? (y/n): "
                if [[ "$OVERRIDE" = "y" ]] ; then
                    rm -f $link
                    ln -s ${DOTFILES["$link"]} $link
                fi
            elif [[ -d $link ]]; then
                 printerr "$link is not a symlink but a directory."
                 overrideQuestion "Override it with symlink to ${DOTFILES["$link"]} ? (y/n): "
                if [[ "$OVERRIDE" = "y" ]] ; then
                    rm -rf $link
                    ln -s ${DOTFILES["$link"]} $link
                fi
            else
                echo "${DOTFILES["$link"]} -> $link"
                ln -s ${DOTFILES["$link"]} $link
            fi
        fi
    else
        if [[ -L $link ]] ; then
            printerr "${DOTFILES["$link"]} doesn't exist but, $link exist and is a symlink."
        else
            printerr "${DOTFILES["$link"]} doesn't exist, but $link exist and is a file/directory."
        fi
    fi
done

execAfterInstall
