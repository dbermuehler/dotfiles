# Install oh-my-zsh if it is not installed yet.
#[[ ! -d $HOME/.oh-my-zsh ]] && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc

# Install zplug plugin manager
[[ ! -d $HOME/.zplug ]] && git clone https://github.com/zplug/zplug $HOME/.zplug
source ~/.zplug/init.zsh

### Plugins ###

zplug "plugins/git", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/copyfile", from:oh-my-zsh
zplug "plugins/copydir", from:oh-my-zsh

zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "jeffreytse/zsh-vi-mode"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#8c8c8c"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

[ -f $HOME/.zshrc-plugins.local ] && source $HOME/.zshrc-plugins.local

if ! zplug check; then zplug install; fi
zplug load

zvm_after_init_commands+=('[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh')

#source "$HOME/.oh-my-zsh/oh-my-zsh.sh"

### User configuration ###

[ -f $HOME/.shell_common ] && source $HOME/.shell_common

setopt APPEND_HISTORY
setopt PROMPT_SUBST
PROMPT='%(5~|%-1~/.../%3~|%4~) %{$fg[cyan]%}>%{$reset_color%} '

[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local
