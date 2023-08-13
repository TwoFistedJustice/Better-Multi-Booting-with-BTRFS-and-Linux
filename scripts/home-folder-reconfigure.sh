#!/bin/bash
# home-folder-reconfigure.sh
# this is now part of home-reconfigure.sh


declare newPath="/mnt/data/"

xdg-user-dirs-update --set DOCUMENTS ${newPath}Documents
xdg-user-dirs-update --set DOWNLOAD ${newPath}Downloads
xdg-user-dirs-update --set MUSIC ${newPath}Music
xdg-user-dirs-update --set PICTURES ${newPath}Pictures
xdg-user-dirs-update --set PUBLICSHARE ${newPath}Public
xdg-user-dirs-update --set TEMPLATES ${newPath}Templates
xdg-user-dirs-update --set VIDEOS ${newPath}Videos
xdg-user-dirs-update
sudo source ~/.config/user-dirs.dirs


