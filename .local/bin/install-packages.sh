#! /usr/bin/env bash

PKGS=(
	niri
	kitty
	neovim
	eza
	fish
	starship	
	git
	qutebrowser

	uwufetch

	pipewire
	pipewire-alsa
	pipewire-pulse
	pipewire-jack

	openssh

	rust
	rust-src
)

# ---------------[REQUEST SUDO]---------------
sudo -v

while true; do
	sudo -n true
	sleep 60
	kill -0 "$$" || exit
done 2> /dev/null &

# ---------------[UPDATE]---------------
echo -e "\x1b[48;5;6;38;5;0m[ Updating system ]\x1b[0m"
sudo pacman -Syyu --noconfirm;

# ---------------[INSTALL]---------------
echo -e "\x1b[48;5;6;38;5;0m[ Updating system ]\x1b[0m"
sudo pacman -S --noconfirm --needed "${PKGS[@]}";

