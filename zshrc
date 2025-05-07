# instantOS zshrc

[ -z "$NOTMUX" ] && [ -z "$TMUX" ] &&
    ! [ "$TERM_PROGRAM" = "vscode" ] &&
    command -v tmux &>/dev/null &&
    exec tmux &&
    exit


zstyle ':fzf-tab:*' use-fzf-default-opts yes
ZIM_CONFIG_FILE=/usr/share/instantshell/zimrc
ZIM_HOME=~/.zim

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"

bindkey -e

zhome=${ZDOTDIR:-$HOME}

isinstantos() {
    command -v pacman &>/dev/null &&
        command -v instantwm &>/dev/null &&
        command -v instantmenu &>/dev/null
}

# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
fi

source ${ZIM_HOME}/init.zsh

export STARSHIP_CONFIG=/usr/share/instantshell/starship.toml
eval "$(starship init zsh)"

export LESS='-R --use-color -Dd+r$Du+b'
alias ls='ls --color=auto'
alias vi=nvim
alias vim=nvim
