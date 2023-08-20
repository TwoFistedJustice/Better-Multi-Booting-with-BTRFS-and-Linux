#!/bin/bash
# Before running you must configure fstab to mount @data to /mnt/data
# This file reconfigures the folders Documents, Downloads, etc to a central place where all distros can access them.
#  It must be run for each distro and assumes you have only one user per machine. Additional users require you to
#  modify the script.
# Be sure to empty the folders PRIOR to running this script
# if the folders are not empty, the script will fail (by design)
# this will work on the current user only

# var string path for XDG user-dirs
declare -r newPath="/mnt/data/"

# var array of folder names
declare -ar folders=("Documents" "Downloads" "Music" "Pictures" "Public" "Templates" "Videos")
# var string path of data folder
declare -r mountPoint="/mnt/data"


# configure XDG ~/.config/user-dirs.dirs
xdg-user-dirs-update --set DOCUMENTS ${newPath}Documents
xdg-user-dirs-update --set DOWNLOAD ${newPath}Downloads
xdg-user-dirs-update --set MUSIC ${newPath}Music
xdg-user-dirs-update --set PICTURES ${newPath}Pictures
xdg-user-dirs-update --set PUBLICSHARE ${newPath}Public
xdg-user-dirs-update --set TEMPLATES ${newPath}Templates
xdg-user-dirs-update --set VIDEOS ${newPath}Videos
xdg-user-dirs-update
sudo source ~/.config/user-dirs.dirs



# cd to home/user,
# if it has Documents folder etc, and they are empty
# remove them
# Make a symlink pointing at /mnt/data/Documents, etc

# cd into home/$USER
cd ~/
# iterate array
for folder in "${folders[@]}"
  do
    echo -e "Beginning work on ${folder}"
    # if folder exists in home/user
    if [[ -d $folder ]]
      then
        echo -e "Removing ${folder}\n"
        #   remove EMPTY folder
        rmdir $folder
        # make symlink of same name pointing to /mnt/data
        sudo ln -s "${mountPoint}/${folder}" $folder
    else
    echo -e "${folder} not found or not empty."
    fi
done






