# Install zplug plugin manager
[[ ! -d $HOME/.zplug ]] && git clone https://github.com/zplug/zplug $HOME/.zplug
source $HOME/.zplug/init.zsh

### Plugins ###

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/branch", from:oh-my-zsh
zplug "plugins/uv", from:oh-my-zsh
zplug "agkozak/zsh-z"

zplug "lib/completion", from:oh-my-zsh
zplug "lib/clipboard", from:oh-my-zsh

zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "softmoth/zsh-vim-mode"

zplug "junegunn/fzf", as:command, hook-build:"./install --bin", use:"bin/{fzf-tmux,fzf}", dir:"$HOME/.fzf"
zplug "so-fancy/diff-so-fancy", as:command

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#8c8c8c"
ZSH_AUTOSUGGEST_STRATEGY=(completion)

[ -f $HOME/.zshrc-plugins.local ] && source $HOME/.zshrc-plugins.local

zplug load

# fzf shell integration (requires fzf to be installed via Homebrew)
eval "$(fzf --zsh)"

# Directory navigation
setopt autocd
setopt autopushd
setopt pushdignoredups

alias d='dirs -v'

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE

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
            AWS_PROMPT="| ☁️ (EXPIRED)"
        else
            AWS_PROMPT="| ☁️ (${AWS_ASSUMED_ROLE}@${AWS_ACCOUNT_NAME})"
        fi

        PROMPT+="$AWS_PROMPT "
    fi

    if [ -n "$VIRTUAL_ENV" ]; then
        local PYTHON_PROMPT="| 🐍"

        if [[ -f "$VIRTUAL_ENV/pyvenv.cfg" ]]; then
            # Read Python version from pyvenv.cfg
            local PY_VERSION=$(grep -m1 '^version_info' "$VIRTUAL_ENV/pyvenv.cfg" | cut -d' ' -f3)
            [[ -n "$PY_VERSION" ]] && PYTHON_PROMPT+=" v$PY_VERSION"

            # Read venv name from prompt field
            local VENV_NAME=$(grep -m1 '^prompt' "$VIRTUAL_ENV/pyvenv.cfg" | cut -d' ' -f3)
            [[ -n "$VENV_NAME" ]] && PYTHON_PROMPT+=" ($VENV_NAME)"
        fi

        PYTHON_PROMPT+=" "
        PROMPT+="$PYTHON_PROMPT"
    fi

    local GIT_PROMPT="$(branch_prompt_info)"
    if [ -n "$GIT_PROMPT" ]; then
        PROMPT+="| 🔀 ($GIT_PROMPT) "
    fi

    local PROMPT_DELIMITER="%{$fg[cyan]%}>%{$reset_color%}"
    PROMPT+="$PROMPT_DELIMITER "
}
precmd_functions+=(my_prompt)

setopt NO_AUTO_MENU

[ -f $HOME/.shell_common ] && source $HOME/.shell_common
[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local
