[ -f $HOME/.shell_common ] && source $HOME/.shell_common

# Tab completion
autoload -Uz compinit && compinit
# case insensitive path-completion 
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 

# Prompt
autoload -U colors && colors
setopt PROMPT_SUBST
PROMPT='%(5~|%-1~/.../%3~|%4~) %{$fg[cyan]%}>%{$reset_color%} '

[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local
