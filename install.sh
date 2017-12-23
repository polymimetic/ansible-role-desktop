#! /usr/bin/env bash
set -e
###########################################################################
#
# Desktop Bootstrap Installer
# https://github.com/polymimetic/ansible-role-desktop
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/ansible-role-desktop/master/install.sh | bash
#
###########################################################################

if [ `id -u` = 0 ]; then
  printf "\033[1;31mThis script must NOT be run as root\033[0m\n" 1>&2
  exit 1
fi

###########################################################################
# Constants and Global Variables
###########################################################################

readonly GIT_REPO="https://github.com/polymimetic/ansible-role-desktop.git"
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/ansible-role-desktop/master"

###########################################################################
# Basic Functions
###########################################################################

# Output Echoes
# https://github.com/cowboy/dotfiles
function e_error()   { echo -e "\033[1;31m✖  $@\033[0m";     }      # red
function e_success() { echo -e "\033[1;32m✔  $@\033[0m";     }      # green
function e_info()    { echo -e "\033[1;34m$@\033[0m";        }      # blue
function e_title()   { echo -e "\033[1;35m$@.......\033[0m"; }      # magenta

###########################################################################
# Install Desktop
# https://yktoo.com/en/software/indicator-sound-switcher
# http://www.omgubuntu.co.uk/2016/09/indicator-sound-switcher-makes-switching-audio-devices-ubuntu-snap
# https://launchpad.net/caffeine
# http://www.omgubuntu.co.uk/2016/07/caffeine-indicator-applet-ubuntu-lock-screen
# https://www.keepassx.org/
# http://ubuntuhandbook.org/index.php/2015/12/install-keepassx-2-0-in-ubuntu-16-04-15-10-14-04/
# https://transmissionbt.com/
# http://www.elinuxbook.com/install-transmission-bittorrent-client-in-ubuntu-16-04/
# https://vpsguide.net/tutorials/vps-tutorials/install-transmission-torrent-client-on-ubuntu-server-and-debian/
# https://www.giuspen.com/cherrytree/
# http://sourcedigit.com/19978-install-cherrytree-text-editor-in-ubuntu-16-04/
# https://github.com/dylanaraps/neofetch
# http://www.omgubuntu.co.uk/2016/11/neofetch-terminal-system-info-app
###########################################################################

install_desktop() {
  e_title "Installing Desktop"

  # Install desktop dependencies
  sudo apt-get install -yq xvfb

  # Add desktop PPA
  if ! grep -q "nilarimogard/webupd8" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:nilarimogard/webupd8
    sudo apt-get update
  fi

  if ! grep -q "yktooo/ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo apt-add-repository -y ppa:yktooo/ppa
    sudo apt-get update
  fi

  if ! grep -q "caffeine-developers/ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo apt-add-repository -y ppa:caffeine-developers/ppa
    sudo apt-get update
  fi

  if ! grep -q "eugenesan/ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo apt-add-repository -y ppa:eugenesan/ppa
    sudo apt-get update
  fi

  if ! grep -q "transmissionbt/ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo apt-add-repository -y ppa:transmissionbt/ppa
    sudo apt-get update
  fi

  if ! grep -q "giuspen/ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo apt-add-repository -y ppa:giuspen/ppa
    sudo apt-get update
  fi

  if ! grep -q "dawidd0811/neofetch" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo apt-add-repository -y ppa:dawidd0811/neofetch
    sudo apt-get update
  fi

  sudo apt-get install -yq neofetch

  sudo apt-get install -yq indicator-sound-switcher

  sudo apt-get install -yq caffeine

  sudo apt-get install -yq keepassx

  sudo apt-get install -yq transmission

  sudo apt-get install -yq cherrytree

  # Install desktop GUI applications
  sudo apt-get install -yq bleachbit meld mpv

  # Install desktop CLI applications
  sudo apt-get install -yq xclip lastpass-cli trash-cli

  # Make sure /usr/local/share/applications exists
  if [[ ! -d /usr/local/share/applications ]]; then
    sudo mkdir -p /usr/local/share/applications
  fi

  # Make sure startup application directory exists
  if [[ ! -d ${HOME}/.config/autostart ]]; then
    mkdir -p ${HOME}/.config/autostart
  fi

  # ls -l /etc/alternatives

  # Set default browser
  update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/firefox 250
  update-alternatives --install /usr/bin/gnome-www-browser gnome-www-browser /usr/bin/firefox 250

  # Kill gnome keyring
  sudo cp /usr/bin/gnome-keyring-daemon /usr/bin/gnome-keyring-daemon-old
  sudo rm /usr/bin/gnome-keyring-daemon
  ps aux | grep gnome-keyring-daemon | grep -v grep
  killall gnome-keyring-daemon

  e_success "Desktop installed"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  install_desktop
}

program_start