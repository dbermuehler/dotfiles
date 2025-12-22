# Install zinit plugin manager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

### Plugins ###

# Oh-My-Zsh plugins
zinit snippet OMZP::branch
zinit snippet OMZP::uv

# Oh-My-Zsh libs
zinit snippet OMZL::completion.zsh
zinit snippet OMZL::clipboard.zsh

# Completions for many CLI tools (docker, aws, jq, etc.)
zinit ice blockf
zinit light zsh-users/zsh-completions

# Third-party plugins
zinit light agkozak/zsh-z

# diff-so-fancy as command
zinit ice as"program" pick"bin/git-dsf"
zinit light so-fancy/diff-so-fancy

zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#8c8c8c"
ZSH_AUTOSUGGEST_STRATEGY=(completion)

# Syntax highlighting should be loaded last
zinit light zsh-users/zsh-syntax-highlighting

# fzf - install binary and shell integration
zinit ice from"gh-r" as"program"
zinit light junegunn/fzf
eval "$(fzf --zsh)" # fzf shell integration (key bindings and completions)

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

# vi keybindings
bindkey -v

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
