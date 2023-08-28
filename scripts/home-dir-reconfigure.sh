#!/bin/bash
# !!!! Before running you must configure fstab to mount @data to /mnt/data !!!!

# This file reconfigures the folders Documents, Downloads, etc to a central place where all distros can access them.
#  It must be run for each distro and assumes you have only one user per machine. Additional users require you to
#  modify the script.
# this will work on the current user only

# var array of folder names
declare -ar folders=("Documents" "Downloads" "Music" "Pictures" "Public" "Templates" "Videos")
# var string path of data folder
declare -r mountPoint="/mnt/data/"


# cd to home/user,
echo -e "Changing to user's home directory/n"
cd ~/
echo -e "results of pwd:"
# display the current location
pwd


# iterate array
for folder in "${folders[@]}"
  do
    echo -e "Beginning work on ${mountPoint}${folder}"
    # if folder does not exist in home/user
    if [[ ! -d $mountPoint$folder ]]
      then
        # make new folders
        echo -e "Making directory ${mountPoint}${folder}\n"
        sudo mkdir -p $mountPoint$folder
        # change owner to main user
        echo -e "Changing owner of ${mountPoint}${folder} to current user\n"
        sudo chown 1000:1000 $mountPoint$folder
        # move contents of old folders to new folders
        echo -e "Moving contents of ~/${folder} to ${mountPoint}${folder}\n"
        mv $folder/* $mountPoint$folder
        # remove old folder if empty
        echo -e "Removing ~/${folder}\n"
        sudo rmdir $folder
        # make symlinks in home pointing to new folders
         sudo ln -s "${mountPoint}${folder}" "${folder}"
    else
      echo -e "${mountPoint}${folder} already exists. Nothing done"
    fi
done
