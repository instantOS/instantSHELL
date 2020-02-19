#!/bin/sh
#
#
# You can tweak the install behavior by setting variables when running the script. For
# example, to change the path to the Oh My Zsh repository:
#   ZSH=~/.zsh sh install.sh
#
# Respects the following environment variables:
#   ZSH     - path to the Oh My Zsh repository folder (default: $HOME/.oh-my-zsh)
#   REPO    - name of the GitHub repo to install from (default: ohmyzsh/ohmyzsh)
#   REMOTE  - full remote URL of the git repo to install (default: GitHub via HTTPS)
#   BRANCH  - branch to check out immediately after install (default: master)
#
# Other options:
#   CHSH    - 'no' means the installer will not change the default shell (default: yes)
#   RUNZSH  - 'no' means the installer will not run zsh after the install (default: yes)
#
# You can also pass some arguments to the install script to set some these options:
#   --skip-chsh: has the same behavior as setting CHSH to 'no'
#   --unattended: sets both CHSH and RUNZSH to 'no'
# For example:
#   sh install.sh --unattended
#
set -e

# Default settings
ZSH=${ZSH:-~/.oh-my-zsh}
REPO=${REPO:-ohmyzsh/ohmyzsh}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
BRANCH=${BRANCH:-master}

# Other options
CHSH=${CHSH:-yes}
RUNZSH=${RUNZSH:-yes}

command_exists() {
	command -v "$@" >/dev/null 2>&1
}

error() {
	echo ${RED}"Error: $@"${RESET} >&2
}

setup_color() {
	# Only use colors if connected to a terminal
	if [ -t 1 ]; then
		RED=$(printf '\033[31m')
		GREEN=$(printf '\033[32m')
		YELLOW=$(printf '\033[33m')
		BLUE=$(printf '\033[34m')
		BOLD=$(printf '\033[1m')
		RESET=$(printf '\033[m')
	else
		RED=""
		GREEN=""
		YELLOW=""
		BLUE=""
		BOLD=""
		RESET=""
	fi
}

setup_zshrc() {
	# Keep most recent old .zshrc at .zshrc.pre-oh-my-zsh, and older ones
	# with datestamp of installation that moved them aside, so we never actually
	# destroy a user's original zshrc
	echo "${BLUE}Looking for an existing zsh config...${RESET}"

	# Must use this exact name so uninstall.sh can find it
	OLD_ZSHRC=~/.zshrc.pre-oh-my-zsh
	if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]; then
		if [ -e "$OLD_ZSHRC" ]; then
			OLD_OLD_ZSHRC="${OLD_ZSHRC}-$(date +%Y-%m-%d_%H-%M-%S)"
			if [ -e "$OLD_OLD_ZSHRC" ]; then
				error "$OLD_OLD_ZSHRC exists. Can't back up ${OLD_ZSHRC}"
				error "re-run the installer again in a couple of seconds"
				exit 1
			fi
			mv "$OLD_ZSHRC" "${OLD_OLD_ZSHRC}"

			echo "${YELLOW}Found old ~/.zshrc.pre-oh-my-zsh." \
				"${GREEN}Backing up to ${OLD_OLD_ZSHRC}${RESET}"
		fi
		echo "${YELLOW}Found ~/.zshrc.${RESET} ${GREEN}Backing up to ${OLD_ZSHRC}${RESET}"
		mv ~/.zshrc "$OLD_ZSHRC"
	fi

	echo "${GREEN}Using the Oh My Zsh template file and adding it to ~/.zshrc.${RESET}"

	cp "$ZSH/templates/zshrc.zsh-template" ~/.zshrc
	sed "/^export ZSH=/ c\\
export ZSH=\"$ZSH\"
" ~/.zshrc >~/.zshrc-omztemp
	mv -f ~/.zshrc-omztemp ~/.zshrc

	echo
}

setup_files() {

	if ! [ -e /usr/share/instantshell ]; then
		echo "required files not found, installation failed"
		exit 1
	fi

	echo "copying files"
	mkdir -p "$ZSH"
	cp -r /usr/share/instantshell/* "$ZSH/"

}

setup_shell() {
	# Skip setup if the user wants or stdin is closed (not running interactively).
	if [ $CHSH = no ]; then
		return
	fi

	# If this user's login shell is already "zsh", do not attempt to switch.
	if [ "$(basename "$SHELL")" = "zsh" ]; then
		return
	fi

	# If this platform doesn't provide a "chsh" command, bail out.
	if ! command_exists chsh; then
		cat <<-EOF
			I can't change your shell automatically because this system does not have chsh.
			${BLUE}Please manually change your default shell to zsh${RESET}
		EOF
		return
	fi

	echo "${BLUE}Time to change your default shell to zsh:${RESET}"

	# Prompt for user choice on changing the default login shell
	printf "${YELLOW}Do you want to change your default shell to zsh? [Y/n]${RESET} "
	read opt
	case $opt in
	y* | Y* | "") echo "Changing the shell..." ;;
	n* | N*)
		echo "Shell change skipped."
		return
		;;
	*)
		echo "Invalid choice. Shell change skipped."
		return
		;;
	esac

	# Check if we're running on Termux
	case "$PREFIX" in
	*com.termux*)
		termux=true
		zsh=zsh
		;;
	*) termux=false ;;
	esac

	# We're going to change the default shell, so back up the current one
	if [ -n "$SHELL" ]; then
		echo $SHELL >~/.shell.pre-oh-my-zsh
	else
		grep "^$USER:" /etc/passwd | awk -F: '{print $7}' >~/.shell.pre-oh-my-zsh
	fi

	# Actually change the default shell to zsh
	if ! chsh -s "$zsh"; then
		error "chsh command unsuccessful. Change your default shell manually."
	else
		export SHELL="$zsh"
		echo "${GREEN}Shell successfully changed to '$zsh'.${RESET}"
	fi

	echo
}

main() {
	# Run as unattended if stdin is closed
	if [ ! -t 0 ]; then
		RUNZSH=no
		CHSH=no
	fi

	# Parse arguments
	while [ $# -gt 0 ]; do
		case $1 in
		--unattended)
			RUNZSH=no
			CHSH=no
			;;
		--skip-chsh) CHSH=no ;;
		esac
		shift
	done

	setup_color

	if ! command_exists zsh; then
		echo "${YELLOW}Zsh is not installed.${RESET} Please install zsh first."
		exit 1
	fi

	if [ -d "$ZSH" ]; then
		cat <<-EOF
			${YELLOW}You already have Oh My Zsh installed.${RESET}
			You'll need to remove '$ZSH' if you want to reinstall.
		EOF
		exit 1
	fi

	setup_files
	setup_zshrc
	setup_shell

	printf "$GREEN"
	cat <<-'EOF'
		         __                                     __
		  ____  / /_     ____ ___  __  __   ____  _____/ /_
		 / __ \/ __ \   / __ `__ \/ / / /  /_  / / ___/ __ \
		/ /_/ / / / /  / / / / / / /_/ /    / /_(__  ) / / /
		\____/_/ /_/  /_/ /_/ /_/\__, /    /___/____/_/ /_/
		                        /____/                       ....is now installed!


		Please look over the ~/.zshrc file to select plugins, themes, and options.

		p.s. Follow us on https://twitter.com/ohmyzsh

		p.p.s. Get stickers, shirts, and coffee mugs at https://shop.planetargon.com/collections/oh-my-zsh

	EOF
	printf "$RESET"

	if [ $RUNZSH = no ]; then
		echo "${YELLOW}Run zsh to try it out.${RESET}"
		exit
	fi

	exec zsh -l
}

main "$@"
