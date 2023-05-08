# Install zplug plugin manager
[[ ! -d $HOME/.zplug ]] && git clone https://github.com/zplug/zplug $HOME/.zplug
source $HOME/.zplug/init.zsh

### Plugins ###

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "plugins/git", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/copypath", from:oh-my-zsh
zplug "plugins/dirhistory", from:oh-my-zsh
zplug "plugins/branch", from:oh-my-zsh
zplug "plugins/copybuffer", from:oh-my-zsh
zplug "agkozak/zsh-z"

zplug "lib/completion", from:oh-my-zsh
zplug "lib/clipboard", from:oh-my-zsh

zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "jeffreytse/zsh-vi-mode"

zplug "junegunn/fzf", as:command, hook-build:"./install --bin", use:"bin/{fzf-tmux,fzf}", dir:"$HOME/.fzf"
zplug "so-fancy/diff-so-fancy", as:command

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#8c8c8c"
ZSH_AUTOSUGGEST_STRATEGY=(completion)

[ -f $HOME/.zshrc-plugins.local ] && source $HOME/.zshrc-plugins.local

if ! zplug check; then zplug install; fi
zplug load

zvm_after_init_commands+=('[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh')
function zvm_after_lazy_keybindings() {
  zvm_define_widget dirhistory_forward
  zvm_define_widget dirhistory_back

  bindkey -M viins '^[^[[C' dirhistory_forward
  bindkey -M viins '^[^[[D' dirhistory_back
}

### User configuration ###

[ -f $HOME/.shell_common ] && source $HOME/.shell_common

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000
setopt SHARE_HISTORY

# Prompt
setopt PROMPT_SUBST

my_prompt() {
    local CURRENT_DIR="%(5~|%-1~/.../%3~|%~)"
    PROMPT="$CURRENT_DIR "

    if [[ -n "$AWS_ASSUMED_ROLE" && -n "$AWS_ACCOUNT_NAME" && -n "$AWS_EXPIRATION_DATE" ]]; then
        local SECONDS_UNTIL_EXPIRED
        local AWS_PROMPT
        (( SECONDS_UNTIL_EXPIRED = $(strftime -r "%Y-%m-%dT%H:%M:%S%z" $(echo $AWS_EXPIRATION_DATE | sed -nr 's/(.+)\+(.+):(.+)/\1+\2\3/p')) - $(date +%s) ))

        if [ $SECONDS_UNTIL_EXPIRED -lt 0 ]; then
            AWS_PROMPT="| ☁️  (EXPIRED) "
        else
            AWS_PROMPT="| ☁️  (${AWS_ASSUMED_ROLE}@${AWS_ACCOUNT_NAME}) "
        fi

        PROMPT+=$AWS_PROMPT
    fi

    if [ -n "$VIRTUAL_ENV" ]; then
        PROMPT+="| 🐍 v$PYENV_VERSION ($(basename $VIRTUAL_ENV | sed -nr 's/([^-]+).+/\1/p')) "
    fi

    local GIT_PROMPT="$(branch_prompt_info)"
    if [ -n "$GIT_PROMPT" ]; then
        PROMPT+="| ($GIT_PROMPT) "
    fi

    local PROMPT_DELIMITER="%{$fg[cyan]%}>%{$reset_color%}"
    PROMPT+="$PROMPT_DELIMITER "
}
precmd_functions+=(my_prompt)

setopt NO_AUTO_MENU

[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local
