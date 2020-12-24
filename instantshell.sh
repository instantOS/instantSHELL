#!/bin/bash

# wrapper for non-interactive installation of instantshell

zshrun() {
    if [ -z "$TMUX" ]; then
        export TMUX=test
        zsh -c "source /usr/share/instantshell/zshrc && $1"
        unset TMUX
    else
        zsh -c "source /usr/share/instantshell/zshrc && $1"
    fi
}

case "$1" in
"install")
    zshrun "echo 'installing'"
    echo "source /usr/share/instantshell/zshrc" > ~/.zshrc
    ;;
"update")
    zshrun "zinit update"
    ;;
esac
