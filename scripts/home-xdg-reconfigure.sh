#!/bin/bash
# home-xdg-reconfigure.sh
# this script reconfigures XDG ~/.config/user.dirs.dirs

# var string path for XDG user-dirs
declare -r newPath="/mnt/data/"

# Add a section which makes the folder in /mnt/data


# configure XDG ~/.config/user-dirs.dirs
xdg-user-dirs-update --set DOCUMENTS ${newPath}Documents
xdg-user-dirs-update --set DOWNLOAD ${newPath}Downloads
xdg-user-dirs-update --set MUSIC ${newPath}Music
xdg-user-dirs-update --set PICTURES ${newPath}Pictures
xdg-user-dirs-update --set PUBLICSHARE ${newPath}Public
xdg-user-dirs-update --set TEMPLATES ${newPath}Templates
xdg-user-dirs-update --set VIDEOS ${newPath}Videos
xdg-user-dirs-update
source ~/.config/user-dirs.dirs

