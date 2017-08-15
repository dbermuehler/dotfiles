#--------------------------------------------------#
#                     Variables                    #
#--------------------------------------------------#

export PATH="$PATH:$HOME/bin:$HOME/.local/bin"
export PROMPT_DIRTRIM=3
export EDITOR=vim
export VISUAL=vim
export BC_ENV_ARGS=~/.bcrc

if [ "$SSH_CONNECTION" ]; then
    PROMPT_HOSTNAME=" | \\h"
fi
if [ "$UID" -ne 0 ]; then
    PROMPT_COLOR="\[\033[38;5;81m\]"
else
    PROMPT_COLOR="\[\033[38;5;160m\]"
fi

export PS1=" \w$PROMPT_HOSTNAME$PROMPT_COLOR > \[$(tput sgr0)\]"

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
alias htop='htop -d 10' # starts htop with an update intervall of 1000 ms
alias doch='su -c "$(history -p !-1)"'
alias speedtest='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test100.zip'

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

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

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

if ! which psgrep >& /dev/null; then
    psgrep() {
        ps -o "pid user:10 tty cmd" -ax | grep "$@" | grep -v grep
    }
fi

spawn() {
    ("$@" &) ; exit
}

calc() {
    bc -l <<< "$@"
}

battery() {
    if [ -e "/sys/class/power_supply/BAT0" ]; then
        BAT_PATH="/sys/class/power_supply/BAT0"
    else
        BAT_PATH="/sys/class/power_supply/BAT1"
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

activate() {
    source ~/PythonEnv/"$1"/bin/activate
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

[ -f ~/.bashrc.local ] && . ~/.bashrc.local
