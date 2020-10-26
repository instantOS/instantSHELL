#!/bin/bash

echo "installing instantshell"

if command -v checkinternet; then
    if ! checkinternet; then
        echo "internet is needed to install instantshell"
    fi
fi

if ! grep -q 'instantshell/zshrc' ~/.zshrc; then
    echo "already installed"
    exit
fi

if ! [ -e ~/.zshrc ]; then
    echo "creating zshrc"
    echo '#!/usr/bin/zsh' >~/.zshrc
fi

if ! [ -e ~/.zinit/bin ]; then
    mkdir ~/.zinit
    git clone --depth=1 https://github.com/zdharma/zinit.git ~/.zinit/bin
fi

{
    echo '# remove the line below to remove instantos tweaks'
    echo 'source /usr/share/instantshell/zshrc'
} >>~/.zshrc

echo 'zinit self-update' | zsh
echo 'zinit update' | zsh

echo "done installing instantos shell configuration"
