#!/bin/bash

# wrapper for non-interactive installation of instantshell

zshrun() {
    if [ -z "$TMUX" ]; then
        export TMUX=test
        zsh -c "cd && source ~/.zshrc && $1"
        unset TMUX
    else
        zsh -c "cd && source ~/.zshrc && $1"
    fi
}

case "$1" in
"install")
    echo "source /usr/share/instantshell/zshrc" >~/.zshrc
    zshrun "echo 'installing'"
    ;;
"reinstall")
    instantshell uninstall "$2" || exit
    instantshell install
    ;;
uninstall)
    if [ "$2" = "-f" ]; then
        CONFIRMATION="y"
    else
        echo -n "this will clear your entire zsh configuration. Continue? (y/n) "
        read -r CONFIRMATION
        echo ""
    fi
    if [ "$CONFIRMATION" = "y" ]; then
        [ -e ~/.zshrc ] && rm ~/.zshrc
        [ -e ~/.cache/antibody ] && rm -rf ~/.cache/antibody
    else
        exit 1
    fi
    ;;
"update")
    zshrun "antibody update"
    ;;
*)
    echo "usage: instantshell [COMMAND]
    install
    reinstall
    uninstall
    update"
    ;;
esac
