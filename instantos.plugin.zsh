# kill all tmux sessions with no terminal emulator attached
tmkill() {
    for i in $(tmux ls | sed '/(attached)$/d;s/: .*$//')
    do
        tmux kill-session -t "$i"
    done
}

sl() {
    sll
}

pb() {
    source /usr/share/paperbash/import.sh || return 1
    pb $@
}

pbf() {
    pushd /usr/share/paperbash || instantinstall paperbash || return 1
    PBCHOICE="$(find . | grep '\.sh' | \
        fzf --preview 'cat {} | grep "()" | grep -o "[^ ]*()" | grep -o "^[^(]*"; printf "\n\n\n########################\n\n"; cat {}')" | sed 's/\.\///g'
    [ -z "$PBCHOICE" ] || return
    pb "$PBCHOICE"
    popd
}

paperbash() {
    source /usr/share/paperbash/import.sh
}

gclone() {
    git clone --depth=1 https://github.com/${1:-paperbenni}/$2.git
}

startx() {
    if ! xhost &>/dev/null; then
        command startx $@
    else
        echo "don't run this in an x session"
        echo "command startx still does it if you absolutely want to"
    fi
}

# [Ctrl-RightArrow] - move forward one word
bindkey -M emacs '^[[1;5C' forward-word
bindkey -M viins '^[[1;5C' forward-word
bindkey -M vicmd '^[[1;5C' forward-word
# [Ctrl-LeftArrow] - move backward one word
bindkey -M emacs '^[[1;5D' backward-word
bindkey -M viins '^[[1;5D' backward-word
bindkey -M vicmd '^[[1;5D' backward-word

zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

alias v=nvim
alias vv="nvim ."

command_not_found_handler() {commandfinder $@}

if [ -e ~/.iprofile ]
then
    source ~/.iprofile
fi

