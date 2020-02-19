#!/bin/sh

umask g-w,o-w

echo "Cloning Oh My Zsh..."
REPO=${REPO:-ohmyzsh/ohmyzsh}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}

git clone -c core.eol=lf -c core.autocrlf=false \
    -c fsck.zeroPaddedFilemode=ignore \
    -c fetch.fsck.zeroPaddedFilemode=ignore \
    -c receive.fsck.zeroPaddedFilemode=ignore \
    --depth=1 --branch "master" "$REMOTE" || {
    error "git clone of oh-my-zsh repo failed"
    exit 1
}
