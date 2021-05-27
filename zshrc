# Created by newuser for 5.8

[ -z "$TMUX" ] && command -v tmux &> /dev/null && exec tmux && exit

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    if checkinternet || curl -s cht.sh &> /dev/null
    then
        print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
        command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
        command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
            print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
            print -P "%F{160}▓▒░ The clone has failed.%f%b"
    fi
fi

source "$HOME/.zinit/bin/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

PS1="ready> " # provide a simple prompt till the theme loads

zinit snippet /usr/share/instantshell/instantos.zsh-theme

setopt promptsubst
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory

zinit snippet OMZL::git.zsh
zinit snippet /usr/share/instantshell/instantos.plugin.zsh

zinit ice wait"1" lucid
zinit light zdharma/fast-syntax-highlighting
zinit ice wait"1" lucid
zinit light zsh-users/zsh-autosuggestions
zinit ice wait"1" lucid
zinit light zsh-users/zsh-completions
zinit ice wait"1" lucid
zinit snippet OMZP::fzf
zinit snippet OMZL::key-bindings.zsh

autoload -Uz compinit
compinit

zinit light agkozak/zsh-z

bindkey -e

zinit light Aloxaf/fzf-tab

