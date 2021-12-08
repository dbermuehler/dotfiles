# Install zplug plugin manager
[[ ! -d $HOME/.zplug ]] && git clone https://github.com/zplug/zplug $HOME/.zplug
source $HOME/.zplug/init.zsh

### Plugins ###

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "plugins/git", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/copydir", from:oh-my-zsh
zplug "plugins/dirhistory", from:oh-my-zsh
zplug "plugins/branch", from:oh-my-zsh
zplug "plugins/copybuffer", from:oh-my-zsh

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

setopt APPEND_HISTORY
setopt PROMPT_SUBST

my_prompt() {
    local CURRENT_DIR="%(5~|%-1~/.../%3~|%4~)"
    PROMPT="$CURRENT_DIR "

    if [ -n "$VIRTUAL_ENV" ]; then
        PROMPT+="($(echo $VIRTUAL_ENV | sed -E 's/.+\/(.+)-.+(-[0-9]+)?$/\1/')) "
    fi

    local GIT_PROMPT="$(branch_prompt_info)"
    if [ -n "$GIT_PROMPT" ]; then
        PROMPT+="($GIT_PROMPT) "
    fi

    local PROMPT_DELIMITER="%{$fg[cyan]%}>%{$reset_color%}"
    PROMPT+="$PROMPT_DELIMITER "
}
precmd_functions+=(my_prompt)

[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local
