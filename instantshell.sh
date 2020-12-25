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
termux)
    echo "installing on termux"
    mkdir -p ~/.cache/instantshell
    cd ~/.cache/ || exit 1
    git clone --depth=1 https://github.com/instantOS/instantSHELL instantshell
    cd instantshell || exit 1
    sed -i '/tmux/d' zshrc
    sed -i 's~/usr/share/instantshell~$HOME/.cache/instantshell~g' zshrc
    echo "source $HOME/.cache/instantshell/zshrc" > ~/.zshrc
    zshrun "echo done"
    ;;
esac
