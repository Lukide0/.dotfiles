#!/usr/bin/env bash

set -euo pipefail

shopt -s nullglob
shopt -s dotglob

msg() 
{
	local color="$1"
	shift
	local title="$1"
	shift

	printf "\e[0;${color}m${title}\e[0m\n"

	if [[ -n "$@" ]]; then
		for line in "$@"
		do
			printf "  ${line}\n"
		done
	fi
}

warning() 
{
	local color=33
	local title="$1"
	shift
	local desc="$@"
	
	msg $color "WARN: $title" "$desc"
}

error() 
{
	local color=31
	local title="$1"
	shift
	local desc="$@"
	
	msg $color "ERROR: $title" "$desc"
}

info() 
{
	local color=36
	local title="$1"
	shift
	local desc="$@"
	
	msg $color "INFO: $title" "$desc"
}

success() 
{
	local color=32
	local title="$1"
	shift
	local desc="$@"
	
	msg $color "SUCCESS: $title" "$desc"
}

request_confirm() 
{
	local message="$1"
	while true; do
		read -rp "$1? (y/n) " yn
		
		case "$yn" in
			[Yy]*)
				return 0
				;;
			[Nn]*)
				return 1
				;;
			*) printf "Please answer y or n\n" ;;
		esac
	done
}

check_installed()
{
	local cmd="$1"
	local required="${2:-false}"

	info "Checking if installed '$cmd' ($( "$required" && printf "REQUIRED" || printf "NOT REQUIRED" ))"

	if ! command -v "$cmd" &>/dev/null; then
	
		msg_title="Command '$cmd' not found"
		if "$required"; then
			error "$msg_title"
		else
			warning "$msg_title"
		fi

		return 1
	fi

	return 0
}

install_packages() 
{
	sudo pacman -S --needed --noconfirm "$@"
}

install_aur_packages()
{
	sudo -u "$(logname)" paru -S --needed --noconfirm "$@"
}


if ! request_confirm "Do you want to install dotfiles"; then
	exit 0
fi

info "Checking distribution"

if [[ ! -e "/etc/arch-release" ]]; then
	error "This script is only for the arch distribution"
	exit 1
fi

info "Updating system packages"
sudo pacman -Syu --noconfirm --needed


# Check if the git is installed
if ! check_installed "git" true; then
	if request_confirm "Do you want to install git"; then
		install_packages "git"
	else
		exit 1
	fi

fi

# Check if the paru is installed
if ! check_installed "paru" true; then
	if request_confirm "Do you want to install paru"; then
		install_packages "base-devel"
		if ! sudo -u "$(logname)" git clone --depth 1 "https://aur.archlinux.org/paru.git"; then
			error "The 'paru' folder already exists" "Please rename or remove 'paru' folder"
			exit 1
		fi

		cd paru
		sudo -u "$(logname)" makepkg -si --clean
		cd ..
		sudo rm -R paru
	else
		exit 1
	fi
fi


if ! check_installed "ly" && request_confirm "Do you want to install 'Ly'(Display manager)"; then
	install_aur_packages "ly"
	if request_confirm "Do you want to set 'Ly' as Display manager"; then
		sudo systemctl enable ly
	fi
fi

# List of all packages
packages=( "alacritty" "bspwm" "dunst" "neovim" "nitrogen" "sxhkd" "ttf-jetbrains-mono-nerd" "picom" "polybar" "ripgrep" "rofi" "unzip" "zsh" )

info "Installing packages" "${packages[*]}"
if request_confirm "Do you want to install them"; then
	install_packages $( printf "${packages[*]}" )
fi

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then

	# Install OhMyZsh
	info "Installing Oh My Zsh"

	sh -c "$(curl -fsSl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if request_confirm "Do you want to install Powerlevel10k theme for Zsh"; then

	# Install Powerlevel10k theme for Zsh
	info "Installing Powerlevel10k theme for Zsh"

	install_aur_packages "zsh-theme-powerlevel10k-git"
	printf "source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc

fi

if request_confirm "Do you want to install Xorg"; then

	info "Installing Xorg"
	# Base
	install_packages "xorg-server" "xorg-xauth" "xorg-xinit" "xorg-xwayland" "xclip"
	# The package that prevents pasting with the middle mouse button
	install_aur_packages "xmousepasteblock"
fi

info "Installing betterlockscreen"
paru -S betterlockscreen

info "Downloading dotfiles"
if [[ -d "$HOME/.dotfiles" ]]; then
	warning "Folder '$HOME/.dotfiles' already exists" "Skipping"
else
	git clone --depth 1 "https://github.com/Lukide0/.dotfiles.git" "$HOME/.dotfiles"
fi

# Create .config if not exists
mkdir -p "$HOME/.config"

warning "Creating symbolic links" "If the folder in $HOME/.config has same name it will be removed"
if request_confirm "Do you create symbolic links"; then
	
	for folder in $HOME/.dotfiles/.config/*; do
		dest="$HOME/.config/$( basename $folder)"

        	if [[ -d "$dest" ]]; then
			    warning "Removing folder '$folder'"
		        rm -Rf $dest
            fi
		

		info "Created link '$folder' \u2192 '$dest'"
		ln -sf "$folder" "$HOME/.config"
	done

    special_links=(".xinitrc" ".xres" ".Xresources" "wallpaper.png")
    for special in "${special_links[@]}"; do

		info "Created link '$HOME/.dotfiles/$special' \u2192 '$HOME/$special'"
	    ln -sf "$HOME/.dotfiles/$special" "$HOME"
    done

    # Lock screen wallpaper
    betterlockscreen -u ~/wallpaper.png --fx blur --blur 0.3
fi

