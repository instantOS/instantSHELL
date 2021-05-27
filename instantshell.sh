#!/bin/bash

# wrapper for non-interactive installation of instantshell

zshrun() {

    if ! command -v zsh &> /dev/null
    then
        echo 'please install zsh'
        return 1
    fi
    
    TMPZSHRC="/tmp/instantos.$(whoami).zshrc.zsh"
    # temporarily disable lazy loading to ensure everything is run
    grep -v '^zinit ice wait' /usr/share/instantshell/zshrc >"$TMPZSHRC"

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
        [ -e ~/.zinit ] && rm -rf ~/.zinit
    else
        exit 1
    fi
    ;;
"update")
    zshrun "zinit update"
    ;;
*)
    echo "usage: instantshell [COMMAND]
    install
    reinstall
    uninstall
    update"
    ;;
esac
