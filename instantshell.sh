#!/bin/bash

# wrapper for non-interactive installation of instantshell

zshrun() {
    TMPZSHRC="/tmp/instantos.$(whoami).zshrc.zsh"
    # temporarily disable lazy loading to ensure everything is ran
    grep -v '^zinit ice wait ' /usr/share/instantshell/zshrc >"$TMPZSHRC"
    if [ -z "$TMUX" ]; then
        export TMUX=test
        zsh -c "source $TMPZSHRC && $1"
        unset TMUX
    else
        zsh -c "source $TMPZSHRC && $1"
    fi
}

case "$1" in
"install")
    zshrun "echo 'installing'"
    echo "source /usr/share/instantshell/zshrc" >~/.zshrc
    ;;
"reinstall")
    if [ "$2" = "-f" ]; then
        CONFIRMATION="y"
    else
        echo "this will clear your existing shell configuration. Continue? (y/n)"
        read -r CONFIRMATION
    fi

    if [ "$CONFIRMATION" = "y" ]; then
        rm ~/.zshrc
        rm -rf ~/.zinit
        zshrun "echo 'installing'"
    fi
    ;;
"update")
    zshrun "zinit update"
    ;;
esac
