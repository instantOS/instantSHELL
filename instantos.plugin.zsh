# kill all tmux sessions with no terminal emulator attached
tmkill() {
    LIST="$(tmux ls)"
    TSESSIONS=""
    while read -r line; do
        if ! echo "$line" | grep 'attached'; then
            tmux kill-session -t "$(echo $line | grep -oP '^\d\d?')"
        fi
    done <<<"$LIST"
}

sl() {
    sll
}

pb() {
    source /usr/share/paperbash/import.sh || return 1
    pb $@
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

paperbash() {
    source /usr/share/paperbash/import.sh
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

if [ -e ~/.iprofile ]
then
    source ~/.iprofile
fi

