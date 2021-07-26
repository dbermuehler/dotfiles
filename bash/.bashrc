[ -e $HOME/.shell_common ] && source $HOME/.shell_common

#--------------------------------------------------#
#                     Variables                    #
#--------------------------------------------------#

export PROMPT_DIRTRIM=3

#--------------------------------------------------#
#                       Prompt                     #
#--------------------------------------------------#

if [ "$SSH_CONNECTION" ]; then
    PROMPT_HOSTNAME=" | \\h"
fi

COLOR_CYAN="\\[\\033[38;5;81m\\]"
COLOR_RED="\\[\\033[38;5;160m\\]"

if tty -s; then
    RESET_COLOR="\\[$(tput sgr0)\\]"
else
    RESET_COLOR="\\[$(echo -en "\e[0m")\\]"
fi

if [ "$(whoami)" = "root" ]; then
    PROMPT_COLOR=$COLOR_RED
else
    PROMPT_COLOR=$COLOR_CYAN
fi

GIT_PROMPT_PATHS=("/usr/share/git/git-prompt.sh" "/usr/lib/git-core/git-sh-prompt" )

for path in "${GIT_PROMPT_PATHS[@]}"; do
    [ -e "$path" ] && GIT_PROMPT_PATH="$path"
done

if [ -e "$GIT_PROMPT_PATH" ]; then
    source "$GIT_PROMPT_PATH"
    GIT_PROMPT="\$(__git_ps1 ' (%s)')"
fi

export PS1=" \\w${PROMPT_HOSTNAME}${GIT_PROMPT}${PROMPT_COLOR} > ${RESET_COLOR}"

#--------------------------------------------------#
#                 History Settings                 #
#--------------------------------------------------#

export HISTCONTROL="ignorespace:ignoredups" # ignores duplicates and commands with space at the beginning
export HISTIGNORE='clear:history' # ignores the commands clear and history
export HISTSIZE="1000000000000000000000000"
export HISTTIMEFORMAT="%y-%m-%d %T "
export PROMPT_COMMAND='history -a' # add history entry to history file after each command and not after exiting the shell
shopt -s histappend # append history to history file and don't override it
shopt -s histreedit # allows to re-edit a failed history substitution
shopt -s histverify # history substitution isn't executed immediately
shopt -s cmdhist # save all lines of a multiple-line command in the same history entry

#--------------------------------------------------#
#                 Tab Completion                   #
#--------------------------------------------------#

[ -e /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion

complete -cf spawn

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

[ -e $HOME/.fzf.bash ] && source $HOME/.fzf.bash
[ -e $HOME/.bashrc.local ] && source $HOME/.bashrc.local
