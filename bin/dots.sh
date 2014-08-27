#!/bin/bash

unset DOTFILES
unset DOTFOLDER
unset OVERRIDE

declare -A DOTFILES
DOTFOLDER="$HOME/.dotfiles"

DOTFILES=(
    ["$HOME/.bashrc"]="$DOTFOLDER/bash/bashrc"
    ["$HOME/.bash_profile"]="$DOTFOLDER/bash/bash_profile"
    ["$HOME/.inputrc"]="$DOTFOLDER/bash/inputrc"
    ["$HOME/.Xresources"]="$DOTFOLDER/Xresources"
    ["$HOME/.vimperatorrc"]="$DOTFOLDER/vimperator/vimperatorrc"
    ["$HOME/.vimperator"]="$DOTFOLDER/vimperator/vimperator_folder"
    ["$HOME/.vimrc"]="$DOTFOLDER/vim/vimrc"
    ["$HOME/.vim"]="$DOTFOLDER/vim/vim_folder"
    ["$HOME/.ctags"]="$DOTFOLDER/ctags"
    ["${XDG_CONFIG_HOME:-$HOME/.config}/herbstluftwm/autostart"]="$DOTFOLDER/herbstluftwm/autostart"
    ["${XDG_CONFIG_HOME:-$HOME/.config}/herbstluftwm/herbstcommander"]="$DOTFOLDER/herbstluftwm/herbstcommander"
)

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

# CASES:
# DOTFILE in dotfiles folder exist AND symlink of it exist
#   -> remove symlink and set new symlink
# DOTFILE in dotfiles folder exist AND symlink don't exist
#   -> create symlink
# DOTFILE in dotfiles folder exist AND symlink don't exist but a normal file
#   -> IF DOTFILE is a file offer diff ELSE offer directory diff
# DOTFILE in dotfiles folder doesn't exist AND symlink is a normal file/directory
#   -> offer to copy file/directory in dotfiles folder
# DOTFILE in dotfiles folder doesn't exist AND symlink exist
#   -> display error message

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
