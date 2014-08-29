#!/bin/bash

unset DOTFILES
unset DOTFOLDER

declare -A DOTFILES

printerr() {
    tput setaf 1
    echo "ERROR:$(tput sgr0) $@"
}

questionTime() {
    unset ANSWER

    read -e -n 1 -p "${@:-Override it? (y/n): }" ANSWER
    while [[ ("$ANSWER" != "y") && ("$ANSWER" != "n") ]] ; do
        printerr "Not a correct option please chose again!"
        read -e -n 1 -p "${@:-Override it? (y/n): }" ANSWER
    done
}

if [[ ! -f "$1" ]]; then
    printerr "Please add an vaild install file as an argument."
    exit 1
fi

. $1

for link in "${!DOTFILES[@]}"; do
    if [[ -e ${DOTFILES["$link"]} ]] ; then
        if [[ -L $link ]]; then
            if [[ ! ($link -ef ${DOTFILES["$link"]}) ]]; then
                printerr "Symlink $link already exist and pointing at $(readlink $link) and not at ${!DOTFILES[@]} like it should."
                questionTime "Should $link link changed to ${!DOTFILES[@]} ? (y/n): "
                if [[ "$ANSWER" = "y" ]] ; then
                    rm $link
                    ln -s ${DOTFILES["$link"]} $link
                fi
            fi
        else
            if [[ -f $link ]]; then
                 printerr "The local dotfile $link already exist."
                 questionTime "Delete local dotfile and add symlink to repo dotfile ${DOTFILES["$link"]} instead? (y/n): "
                if [[ "$ANSWER" = "y" ]] ; then
                    rm -f $link
                    ln -s ${DOTFILES["$link"]} $link
                fi
            elif [[ -d $link ]]; then
                 printerr "The local dotfolder $link already exist."
                 questionTime "Delete local dotfolder and add symlink to repo dotfolder ${DOTFILES["$link"]} instead? (y/n): "
                if [[ "$ANSWER" = "y" ]] ; then
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
