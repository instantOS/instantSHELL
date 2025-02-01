# instantOS zshrc

[ -z "$NOTMUX" ] && [ -z "$TMUX" ] &&
    ! [ "$TERM_PROGRAM" = "vscode" ] &&
    command -v tmux &>/dev/null &&
    exec tmux &&
    exit

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"

setopt promptsubst
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory

autoload -Uz compinit
compinit

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC="true"
bindkey -e

zhome=${ZDOTDIR:-$HOME}

isinstantos() {
    command -v pacman &>/dev/null &&
        command -v instantwm &>/dev/null &&
        command -v instantmenu &>/dev/null
}

install_antidote_plugins() {
    echo "loading plugin bundle"
    [ -e "$HOME/.cache/zsh" ] || mkdir -p "$HOME/.cache/zsh"
    BUNDLEFILE="${BUNDLEFILE:-/usr/share/instantshell/bundle.txt}"
    # clone antidote if necessary and generate a static plugin file
    cloneantidote() {
        ANTIDOTEURL=/usr/share/instantshell/antidote
        [ -e "$ANTIDOTEURL" ] || ANTIDOTEURL=https://github.com/mattmc3/antidote.git
        git clone --depth=1 "$ANTIDOTEURL" $zhome/.antidote
    }
    if [[ ! $zhome/.zsh_plugins.zsh -nt $zhome/.zsh_plugins.txt ]]; then
        [[ -e $zhome/.antidote ]] || cloneantidote
        [[ -e $zhome/.zsh_plugins.txt ]] || touch $zhome/.zsh_plugins.txt
        (
            source $zhome/.antidote/antidote.zsh
            BUNDLESTUFF=$(cat "$BUNDLEFILE")
            if ! isinstantos; then
                BUNDLESTUFF="$(grep -v instantos <<<"$BUNDLESTUFF")"
            fi
            antidote bundle <<<"$BUNDLESTUFF" >$zhome/.zsh_plugins.zsh
        )
    fi
}

alias iantidote="source $zhome/.antidote/antidote.zsh"

if ! [ -e $zhome/.zsh_plugins.zsh ]; then
    install_antidote_plugins
fi

source $zhome/.zsh_plugins.zsh

export STARSHIP_CONFIG=/usr/share/instantshell/starship.toml
eval "$(starship init zsh)"

export LESS='-R --use-color -Dd+r$Du+b'
alias ls='ls --color=auto'
alias vi=nvim
alias vim=nvim
