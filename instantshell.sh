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
    [ -e "$HOME"/.cache/antidote ] || mkdir -p ~/.cache/antidote/
    echo "source /usr/share/instantshell/zshrc" >~/.zshrc
    zshrun "install_antidote_plugins" || exit 1
    zshrun "echo 'installing'" || exit 1
    echo "instantSHELL installation complete"
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
        [ -e ~/.cache/antidote/ ] && rm -rf ~/.cache/antidote/
    else
        exit 1
    fi
    ;;
"update")
    [ -e "$HOME"/.cache/antidote ] && mkdir -p ~/.cache/antidote/
    zshrun "iantidote; antidote update"
    zshrun "iantidote; antidote bundle < /usr/share/instantshell/bundle.txt > ~/.zsh_plugins.sh "
    ;;
*)
    echo "usage: instantshell [COMMAND]
    install     install all instantSHELL dotfiles
    reinstall   remove and install all instantSHELL dotfiles
    uninstall   remove instantSHELL dotfiles
    update      update zsh plugins"
    ;;
esac
