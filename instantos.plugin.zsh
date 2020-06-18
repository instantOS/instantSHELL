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

alias v=nvim
