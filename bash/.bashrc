#--------------------------------------------------#
#                     Variables                    #
#--------------------------------------------------#

export PATH="$HOME/bin:$PATH"
export PS1='[\w] \$ '
export PROMPT_DIRTRIM=3
export BROWSER=firefox
export EDITOR=vim
export BC_ENV_ARGS=~/.bcrc

#--------------------------------------------------#
#                     Aliases                      #
#--------------------------------------------------#

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias mkdir='mkdir -p'
alias cp='cp -r'
alias vim='vim -p'
alias hg='history | grep' # may conflict with Mercurial, but since I'm not using it this will be no problem
alias pps='ps -o "pid cmd" -fx'
alias vim_private="vim -i NONE --cmd 'set noswapfile' --cmd 'set nobackup' --noplugin"
alias bc='bc -l'

#--------------------------------------------------#
#                 History Settings                 #
#--------------------------------------------------#

export HISTCONTROL="ignorespace:ignoredups" # ignores duplicates and commands with space at the beginning
export HISTIGNORE='clear:history' # ignores the commands clear and history
export HISTSIZE="100000"
export PROMPT_COMMAND='history -a' # add history entry to history file after each command and not after exiting the shell
shopt -s histappend # append history to history file and don't override it
shopt -s histreedit # allows to re-edit a failed history substitution
shopt -s histverify # history substitution isn't executed immediately
shopt -s cmdhist # save all lines of a multiple-line command in the same history entry

#--------------------------------------------------#
#                 Tab Completion                   #
#--------------------------------------------------#

if [ -f /etc/bash_completion ]; then
   . /etc/bash_completion.d/*
fi

complete -cf spawn
complete -f rename

#--------------------------------------------------#
#                    Functions                     #
#--------------------------------------------------#

# draw a horizontal line
hr(){
    yes -- "${@:-\-}" | tr -d $'\n' | head -c $COLUMNS
}

function cd() {
    if [[ -z "$@" ]]; then
        clear
        builtin cd
    else
        clear
        builtin cd "$@" && pwd && ls;
    fi
}

sp(){
    if [[ "$1" = "-d" ]] ; then
        [[ "$PWD" = "/tmp/scratchpad" ]] && cd
        rm -r /tmp/scratchpad
        return 0
    else
        [[ ! -d /tmp/scratchpad ]] && mkdir /tmp/scratchpad
        cp "$1" /tmp/scratchpad
        cd /tmp/scratchpad
    fi
}

psgrep() {
    ps -o "pid user:10 tty cmd" -ax | grep "$@" | grep -v grep
}

spawn() {
    ("$@" &) ; exit
}

rename() {
    # change the internal field seperator, so that we can handle filenames with spaces correctly
    saveIFS="$IFS"
    IFS=$(echo -en "\n\b")

    unset verbose regex file files

    # only print out the old and new file but don't rename the file
    if [ "$1" = "-v" ]; then
        verbose=1
        shift
    fi

    if [ $# -lt 2 ]; then
        echo "Usage: rename [-v] sedexpr filenames"
        echo "Example: rename 's/lecture([0-9])\.pdf/Lecture_0\1.pdf/' lecture*"
        return
    fi

    regex="'$1'"
    shift
    files=($@)

    # check if the files to rename exist
    if ! ls "$@" >& /dev/null; then
        echo "Couldn't rename files: files or directory not found"
        return
    fi

    for file in "${files[@]}"; do
        if ! new_file="$(eval "sed -r $regex <<< $file")"; then
            echo "ERROR: Didn't rename $file due to an error in the regex"
            continue
        fi

        # no change in filename -> no need to rename
        [ "$file" = "$new_file" ] && continue

        if [ "$verbose" ]; then
            echo "$file -> $new_file"
        else
            mv "$file" "$new_file"
        fi
    done

    IFS="$saveIFS"
    unset verbose regex file files saveIFS
}

calc () {
    bc -l <<< "$@"
}

#--------------------------------------------------#
#                     Misc                         #
#--------------------------------------------------#

shopt -s autocd # if a command has the same name as a directory it will cd in this directory
shopt -s globstar # ** will match all files and zero or more directories and subdirectories
shopt -s cdspell # will check and correct minor spelling mistakes in directory names
shopt -s checkwinsize # window size is checked after each command, if needed it will udpate LINES and COLUMNES

# deactivate flow control if stdin is a terminal
if [ -t 0 ]; then
    stty -ixon
fi

#--------------------------------------------------#
#              Import local settings               #
#--------------------------------------------------#

. ~/.bashrc.local
