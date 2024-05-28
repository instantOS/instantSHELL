# instantOS zshrc

[ -z "$NOTMUX" ] && [ -z "$TMUX" ] && ! [ "$TERM_PROGRAM" = "vscode" ] && command -v tmux &> /dev/null && exec tmux && exit

# TODO: new colorscheme
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=dark
--color=fg:-1,bg:-1,hl:#CE50DD,fg+:#ffffff,bg+:#626A7E,hl+:#E0527E
--color=info:#4BEC90,prompt:#6BE5E7,pointer:#E7766B,marker:#CFCD63,spinner:#5293E1,header:#579CEF
'

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
    command -v pacman &> /dev/null && \
        command -v instantwm &> /dev/null && \
        command -v instantmenu &> /dev/null
    # TODO parse etc stuff
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
            if ! isinstantos
            then
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
