#! /usr/bin/env bash

# ---------------[VERIFY ARGS]---------------
if [[ -z "$1" ]]; then
	echo -e "\x1b[48;5;196;38;5;0m[ INVALID ARGS ]\x1b[0m"
	echo -e "\x1b[38;5;6mUsage:\x1b[38;5;2m $0 \x1b[38;5;5m<path to pkg file>\x1b[0m"
	exit;
fi

# ---------------[REQUEST SUDO]---------------
sudo -v

while true; do
	sudo -n true
	sleep 60
	kill -0 "$$" || exit
done 2> /dev/null &

# ---------------[UPDATE]---------------
echo -e "\x1b[48;5;6;38;5;0m[ Updating system ]\x1b[0m"
sudo pacman -Syyu

# ---------------[INSTALL]---------------
echo -e "\x1b[48;5;6;38;5;0m[ Updating system ]\x1b[0m"
sudo pacman -S --needed - < "$1";

