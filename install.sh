#!/usr/bin/env bash

set -euo pipefail

shopt -s nullglob dotglob

###########
# Logging #
###########

log_msg() {
    local color="$1"
    shift
    local title="$1"
    shift

    printf "\e[0;${color}m${title}\e[0m\n"

    if [[ -n "$@" ]]; then
        for line in "$@"; do
            printf "  ${line}\n"
        done
    fi
}

log_warn() {
    local color=33
    local title="$1"
    shift
    local desc="$@"

    log_msg $color "WARN: $title" "$desc"
}

log_err() {
    local color=31
    local title="$1"
    shift
    local desc="$@"

    log_msg $color "ERROR: $title" "$desc"
}

log_info() {
    local color=36
    local title="$1"
    shift
    local desc="$@"

    log_msg $color "INFO: $title" "$desc"
}

log_success() {
    local color=32
    local title="$1"
    shift
    local desc="$@"

    log_msg $color "SUCCESS: $title" "$desc"
}

request_confirm() {
    local message="$1"

    while true; do
        read -rp "$message? (y/n) " yn

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

check_installed() {
    local cmd="$1"
    local required="${2:-false}"
    local label=$([[ "$required" == true ]] && echo "Required" || echo "Optional")

    log_info "Checking if installed '$cmd' ($label)"

    if ! command -v "$cmd" &>/dev/null; then

        msg_title="Command '$cmd' not found"
        if "$required"; then
            log_err "$msg_title"
        else
            log_warn "$msg_title"
        fi

        return 1
    fi

    return 0
}

install_packages() {
    sudo pacman -S --needed --noconfirm "$@"
}

install_aur_packages() {
    sudo -u "$(logname)" paru -S --needed --noconfirm "$@"
}

###############################################################################
# Installation
###############################################################################

if ! request_confirm "Do you want to install dotfiles"; then
    exit 0
fi

log_info "Checking distribution"

if [[ ! -e "/etc/arch-release" ]]; then
    log_err "This script is only for the arch distribution"
    exit 1
fi

log_info "Updating system packages"
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
            log_err "The 'paru' folder already exists" "Please rename or remove 'paru' folder"
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
packages=("alacritty" "bspwm" "dunst" "neovim" "nitrogen" "sxhkd" "ttf-jetbrains-mono-nerd" "papirus-icon-theme" "picom" "polybar" "ripgrep" "rofi" "unzip" "zsh")
special_links=("wallpaper.png")

log_info "Installing packages" "${packages[*]}"
if request_confirm "Do you want to install the above packages"; then
    install_packages $(printf "${packages[*]}")
fi

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then

    # Install OhMyZsh
    log_info "Installing Oh My Zsh"

    sh -c "$(curl -fsSl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if request_confirm "Do you want to install Powerlevel10k theme for Zsh"; then

    # Install Powerlevel10k theme for Zsh
    log_info "Installing Powerlevel10k theme for Zsh"
    git clone --depth 1 "https://github.com/romkatv/powerlevel10k.git" ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

    special_links+=(".zshrc")
fi

if request_confirm "Do you want to install Xorg"; then

    log_info "Installing Xorg"
    # Base
    install_packages "xorg-server" "xorg-xauth" "xorg-xinit" "xorg-xwayland" "xclip"
    # The package that prevents pasting with the middle mouse button
    install_aur_packages "xmousepasteblock"

    special_links+=(".xinitrc" ".xres" ".Xresources")
fi

log_info "Downloading dotfiles"
if [[ -d "$HOME/.dotfiles" ]]; then
    log_warn "Folder '$HOME/.dotfiles' already exists" "Skipping"
else
    git clone --depth 1 "https://github.com/Lukide0/.dotfiles.git" "$HOME/.dotfiles"
fi

# Create .config if not exists
mkdir -p "$HOME/.config"

log_warn "Creating symbolic links" "If the folder in $HOME/.config has same name it will be removed"
if request_confirm "Do you create symbolic links"; then

    for folder in $HOME/.dotfiles/.config/*; do
        dest="$HOME/.config/$(basename $folder)"

        if [[ -d "$dest" ]]; then
            log_warn "Removing folder '$folder'"
            rm -Rf $dest
        fi

        log_info "Created link '$folder' \u2192 '$dest'"
        ln -sf "$folder" "$HOME/.config"
    done

    for special in "${special_links[@]}"; do

        log_info "Created link '$HOME/.dotfiles/$special' \u2192 '$HOME/$special'"
        ln -sf "$HOME/.dotfiles/$special" "$HOME"
    done

fi

log_success "Done"
