#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be the root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

# Change Debian to SID branch
# cp /etc/apt/sources.list /etc/apt/sources/list/bak
# cp sources.list /etc/apt/sources.list

username=dcopel1
builddir=$(pwd)

# Update packages list and update system
#apt update
#apt upgrade -y

# Making .config and Moving config files and background to Pictures.
cd $builddir
mkdir -p /home/dcopel1/.config
mkdir -p /home/$username/.fonts
mkdir -p /home/$username/Pictures
mkdir -p /usr/share/sddm/themes
cp .Xresources /home/$username
cp .Xnord /home/$username
cp -R dotconfig/* /home/$username/.config/
cp bg.jpg /home/$username/Pictures/
mv user-dirs.dirs /home/$username/.config
chown -R $username:$username /home/$username
tar -xzvf sugar-candy.tar.gz -C /usr/share/sddm/themes
mv /home/$username/.config/sddm.conf /etc/sddm.conf

# Installing sugar-candy dependencies
nala install libqt5svg5 qml-module-qtquick-controls qml-module-qtquick-controls2 -y
# Installing Essential Programs
nala install feh bspwm sxhkd kitty rofi polybar picom thunar nitrogen lxpolkit x11-xserver-utils unzip yad wget pulseaudio pavucontrol tldr -y
# Installing other less important Programs
nala install neofetch flameshot psmisc mangohud lxappearance papirus-icon-theme fonts-noto-color-emoji sddm -y

# Download Nordic Theme
cd /usr/share/themes/
git clone https://github.com/EliverLara/Nordic.git

# Install Nordzy cursor
cd $builddir
git clone https://github.com/alvatip/Nordzy-cursors
cd Nordzy-cursors
./install.sh
cd $builddir
rm -rf Nordzy-cursors

# Configure bash to use nala wrapper instead of apt
ubashrc="/home/dcopel1/.bashrc"
rbashrc="/root/.bashrc"
if [ -f "$ubashrc" ]; then
cat << \EOF >> "$ubashrc"
apt() {
  command nala "$@"
}
sudo() {
  if [ "$1" = "apt" ]; then
    shift
    command sudo nala "$@"
  else
    command sudo "$@"
  fi
}
EOF
fi

if [ -f "$rbashrc" ]; then
cat << \EOF >> "$rbashrc"
apt() {
  command nala "$@"
}
EOF
fi

# Polybar configuration
bash scripts/changeinterface
