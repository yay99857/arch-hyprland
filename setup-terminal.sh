#!/usr/bin/env bash
set -euo pipefail


# Colors
CRE=$(tput setaf 1)    # Red
CYE=$(tput setaf 3)    # Yellow
CGR=$(tput setaf 2)    # Green
CBL=$(tput setaf 4)    # Blue
BLD=$(tput bold)       # Bold
CNC=$(tput sgr0)       # Reset colors

# Header Logger
header() {
    text="$1"
    printf "%b" "
   ${BLD}${CRE}[ ${CYE}${text} ${CRE}]${CNC}\n\n"
}

header "Created by Phunt_Vieg_"
sleep 2
header "Edited by yay99857"
sleep 2
clear

cd ~

header "Updating packages..."
sudo pacman -Syu --noconfirm

sleep 1
clear
header "Setting locale en_US.UTF-8"
sudo sed -i '/^#en_US.UTF-8 UTF-8/s/^#//' /etc/locale.gen
sudo locale-gen
sudo localectl set-locale LANG=en_US.UTF-8

sleep 1
header "==> Download yay package manager"
sudo pacman -S --noconfirm --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ~
rm -rf ~/yay

pkgs=(
    # System monitoring and fun terminal visuals
    btop fastfetch

    # Essential utilities
    make curl wget unzip dpkg fzf eza bat zoxide neovim tmux ripgrep fd stow man openssh netcat lazygit

    # CTF tools
    perl-image-exiftool gdb ascii

    # Programming languages
    python3 python-pip nodejs npm go

    # Shell & customization
    zsh
)
sudo pacman -S --noconfirm "${pkgs[@]}"

sleep 1
header "Allow pip3 install by removing EXTERNALLY-MANAGED file"
sudo rm -rf $(python3 -c "import sys; print(f'/usr/lib/python{sys.version_info.major}.{sys.version_info.minor}/EXTERNALLY-MANAGED')")

sleep 1
header "Download pwndbg and pwntools"
git clone --depth=1 https://github.com/pwndbg/pwndbg
cd pwndbg
./setup.sh
cd ..
pip3 install pwntools

clear
header "Oh-My-Posh"
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

clear
header "Downloading dotfiles"
git clone --depth=1 https://github.com/yay99857/Dotfiles.git ~/dotfiles
git clone --depth=1 https://github.com/tmux-plugins/tpm ~/dotfiles/.tmux/plugins/tpm

clear
header "Stow"
cd ~/dotfiles
rm -rf .git README.md
stow -t ~ .
cd ~

clear
header "Setting zsh to default shell"
ZSH_PATH="$(which zsh)"
grep -qxF "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells
chsh -s "$ZSH_PATH"

clear
header "==> Please restart your terminal to finish."
