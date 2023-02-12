#!/bin/sh

echo "Installing packages"
pacman -Sy xorg-server xorg-xauth sddm bspwm sxhkd rofi alacritty picom nitrogen git dunst papirus-icon-theme zsh

systemctl enable sddm

echo "Downloading paru"
pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

echo "Downloading betterlockscreen"

paru -S betterlockscreen
# update lock screen background
betterlockscreen -u ~/wallpaper.png --fx blur --blur 0.3

echo "Downloading and installing fonts"
pacman -S ttf-jetbrains-mono-nerd

echo "Changing shell"
chsh -s $(which zsh)
