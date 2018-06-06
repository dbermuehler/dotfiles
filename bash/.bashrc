#--------------------------------------------------#
#                     Variables                    #
#--------------------------------------------------#

export PATH+=":$HOME/bin:$HOME/.local/bin"
export PROMPT_DIRTRIM=3
export EDITOR=vim
export VISUAL=vim
export BC_ENV_ARGS=~/.bcrc

#--------------------------------------------------#
#                       Prompt                     #
#--------------------------------------------------#

if [ "$SSH_CONNECTION" ]; then
    PROMPT_HOSTNAME=" | \\h"
fi

COLOR_CYAN="\\[\\033[38;5;81m\\]"
COLOR_RED="\\[\\033[38;5;160m\\]"
RESET_COLOR="\\[$(tput sgr0)\\]"

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
#                     Aliases                      #
#--------------------------------------------------#

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias mkdir='mkdir -p'
alias cp='cp -r'
alias vim='vim -p'
alias vim_private="vim -i NONE --cmd 'set noswapfile' --cmd 'set nobackup' --noplugin"
alias bc='bc -l'
alias doch='su -c "$(history -p !-1)"'
alias speedtest='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test100.zip'
alias htop='htop -d 10' # starts htop with an update intervall of 1000 ms

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

[ -e /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion

complete -cf spawn

#--------------------------------------------------#
#                    Functions                     #
#--------------------------------------------------#

# draw a horizontal line
hr(){
    yes -- "${@:-"-"}" | tr -d $'\n' | head -c $COLUMNS
}

function cd() {
    if [[ -z "$*" ]]; then
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

spawn() {
    ("$@" &) ; exit
}

calc() {
    bc -l <<< "$@"
}

battery() {
    if [ -e "/sys/class/power_supply/BAT0" ]; then
        local BAT_PATH="/sys/class/power_supply/BAT0"
    else
        local BAT_PATH="/sys/class/power_supply/BAT1"
    fi

    CAPACITY="$(< $BAT_PATH/capacity)%"

    case "$(cat $BAT_PATH/status)" in
        Discharging)
            echo "$CAPACITY discharging"
            ;;
        Charging)
            echo "$CAPACITY charging"
            ;;
        *)
            echo "Fully charged"
            ;;
    esac
}

p() {
    # Search and open recently opened PDFs with zathura.
    DEPENDENCIES=( 'fzf' 'zathura' 'pdfinfo' )

    for DEPENDENCY in "${DEPENDENCIES[@]}"; do
        if [ ! "$(command -v "$DEPENDENCY")" ]; then
            echo "$DEPENDENCY is not install. Please install it first to use this function."
            return 1
        fi
    done

    awk 'BEGIN {
        RS="\n\n"
        FS="\n"
        OFS="\t"
    }
    {
        gsub(/\[|\]|time=/,"")
    }
    /^[^#]/ {
        print $10,$1 | "sort -k 1 -r "
    }' "$HOME/.local/share/zathura/history" |
    cut -f2- |

    while read -r PDF_PATH; do
        [ -e "$PDF_PATH" ] && echo "$PDF_PATH";
    done |

    fzf --multi \
        --exit-0 \
        --select-1 \
        --query="$*" \
        --cycle \
        --height=100 \
        --preview-window=down:4 \
        --preview="pdfinfo {} | grep --color=never -E '^(Title|Subject|Keywords|Author):[ ]+[^ ]'" |

    xargs --no-run-if-empty -i zathura --fork '{}'
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

[ -f ~/.bashrc.local ] && source ~/.bashrc.local
