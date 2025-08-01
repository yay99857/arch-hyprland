#!/usr/bin/env bash
set -euo pipefail

#	Author	-	ViegPhunt
#	Edited  -   yay99857
#	Repo	-	https://github.com/yay99857/arch-hyprland
#	script to install my dotfiles

# Colors
CRE=$(tput setaf 1)    # Red
CYE=$(tput setaf 3)    # Yellow
CGR=$(tput setaf 2)    # Green
CBL=$(tput setaf 4)    # Blue
BLD=$(tput bold)       # Bold
CNC=$(tput sgr0)       # Reset colors

# Header Logger
# Logo
header() {
    text="$1"
    printf "%b" "
   ${BLD}${CRE}[ ${CYE}${text} ${CRE}]${CNC}\n\n"
}

# Logo
logo() {
    text="$1"
    printf "%b" "
    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠛⠛⠉⠉⠉⠙⠻⣅⠀⠈⢧⠀⠈⠛⠉⠉⢻
    ⣿⣿⣿⣿⣿⣿⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⣤⡶⠟⠀⠀⣈⠓⢤⣶⡶⠿⠛⠻
    ⣿⣿⣿⣿⣿⢣⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣀⣴⠶⠿⠿⢷⡄⠀⠀⢀⣤⣾
    ⣿⣿⣿⣿⣡⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣦⣤⣤⡀⠀⢷⡀⠀⠀⣻
    ⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡈⠛⠶⠛⠃⠈⠈⢿
    ⣿⣿⠟⠘⠀⠀⠀⠀⠀⠀⠀⠀⢀⡆⠀⠀⠀⠀⠀⠀⣧⠀⠀⠀⠀⠀⠀⠈⣿
    ⣿⠏⠀⠁⠀⠀⠀⠀⠀⠀⠀⢀⣶⡄⠀⠀⠀⠀⠀⠀⣡⣄⣿⡆⠀⠀⠀⠀⣿
    ⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠚⠛⠛⢛⣲⣶⣿⣷⣉⠉⢉⣥⡄⠀⠀⠀⠨
    ⡇⢠⡆⠀⠀⢰⠀⠀⠀⠀⢸⣿⣧⣠⣿⣿⣿⣿⣿⣿⣷⣾⣿⡅⠀⠀⡄⠠⢸
    ⣧⠸⣇⠀⠀⠘⣤⡀⠀⠀⠘⣿⣿⣿⣿⣿⠟⠛⠻⣿⣿⣿⡿⢁⠀⠀⢰⠀⢸
    ⣿⣷⣽⣦⠀⠀⠙⢷⡀⠀⠀⠙⠻⠿⢿⣷⣾⣿⣶⠾⢟⣥⣾⣿⣧⠀⠂⢀⣿

   ${BLD}${CRE}[ ${CYE}${text} ${CRE}]${CNC}\n\n"
}

clear

logo "Starting..."

cd ~

header "==> Updating system packages..."
sudo pacman -Syu --noconfirm

sleep 3
clear
header "==> Setup Terminal"
bash -c "$(curl -fSL https://raw.githubusercontent.com/yay99857/arch-hyprland/main/setup-terminal.sh)"

sleep 2
clear
header "==> Make executable"
sudo chmod +x ~/dotfiles/.config/yay9857/*

clear
header "==> Download wallpapers"
git clone --depth 1 https://github.com/yay99857/wallpapers.git ~/Wallpapers
mkdir -p ~/Pictures/Wallpapers
mv ~/Wallpapers/Wallpapers/* ~/Pictures/Wallpapers
rm -rf ~/Wallpapers

clear
header "==> Install package"
~/dotfiles/.config/yay9857/install_archpkg.sh

clear
header "==> Enable bluetooth"
sudo systemctl enable --now bluetooth

header "==> Enable networkmanager"
sudo systemctl enable --now NetworkManager

clear
header "==> Set Ghostty as the default terminal emulator for Nemo"
gsettings set org.cinnamon.desktop.default-applications.terminal exec ghostty

clear
header "==> Set Cursor"
~/dotfiles/.config/yay9857/setcursor.sh

clear
header "==> Stow dotfiles"
cd ~/dotfiles
stow -t ~ .
cd ~

clear
header "==> Check display manager"
if [[ ! -e /etc/systemd/system/display-manager.service ]]; then
    sudo systemctl enable sddm
    echo -e "[Theme]\nCurrent=sugar-candy" | sudo tee -a /etc/sddm.conf
    echo "sddm has been enabled."
fi


clear
echo
header "Installation successfully."
