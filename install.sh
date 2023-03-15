#!/usr/bin/env bash

readonly files=('.xinitrc' 'wallpaper.png' '.zshrc' '.p10k.zsh')
readonly config_folders=('betterlockscreen' 'bspwm' 'dunst' 'nvim' 'picom' 'polybar' 'rofi' 'sxhkd' 'alacritty')

dotfiles_dir=$( dirname -- $0 )
contains_git=$( git -C $dotfiles_dir rev-parse 2>/dev/null )

# Check if dotfiles directory is git repo
if [[ ! contains_git ]]; then
    echo "Directory '$dotfiles_dir' is not git repo!"
    exit
fi

exists=0
# Check if files exists
for file in "${files[@]}"; do
    if [[ -f $HOME/$file ]]; then
        echo "File '$HOME/$file' already exists!"
        exists=1
    fi
done

# Check if folders exists
for folder in "${config_folders[@]}"; do
    if [[ -d $HOME/.config/$folder ]]; then
        echo "Folder '$HONE/.config/$folder' already exists!"
        exists=1
    fi
done

if [[ exists -eq 1 ]]; then
    exit 0
fi

echo "Creating symbolic links:"
for file in "${files[@]}"; do
    ln -s $dotfiles_dir/$file $HOME
    echo "    $dotfiles_dir/$file -> $HOME/$file"
done

for folder in "${config_folders[@]}"; do
    ln -s $dotfiles_dir/.config/$folder $HOME/.config
    echo "    $dotfiles_dir/.config/$folder -> $HOME/.config/$folder"
done

echo "Installing packages:"

pacman -Sy           \
  xorg-server        \
  xorg-xauth         \
  sddm               \
  bspwm              \
  sxhkd              \
  rofi               \
  alacritty          \
  picom              \
  nitrogen           \
  git                \
  dunst              \
  papirus-icon-theme \
  zsh

systemctl enable sddm

echo "Downloading and installing paru:"

pacman -S --needed base-devel

git clone https://aur.archlinux.org/paru.git
( cd paru && makepkg -si )
rm -r paru 


echo "Downloading betterlockscreen:"
paru -S betterlockscreen

betterlockscreen -u ~/wallpaper.png --fx blur --blur 0.3

echo "Downloading and installing fonts:"
pacman -S ttf-jetbrains-mono-nerd

echo "Changing shell"
chsh -s $(which zsh)


echo "Done"