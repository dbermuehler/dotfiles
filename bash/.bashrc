#--------------------------------------------------#
#                     Variables                    #
#--------------------------------------------------#

export PATH="$HOME/bin:$PATH"
export PS1=' \w\[\033[38;5;81m\] ❯ \[$(tput sgr0)\]'
export PROMPT_DIRTRIM=3
export BROWSER=firefox
export EDITOR=vim
export VISUAL=vim
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
alias htop='htop -d 10' # starts htop with an update intervall of 1000 ms
alias weather='curl http://wttr.in/'

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

#--------------------------------------------------#
#                    Functions                     #
#--------------------------------------------------#

# draw a horizontal line
hr(){
    yes -- "${@:-"-"}" | tr -d $'\n' | head -c $COLUMNS
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

calc() {
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