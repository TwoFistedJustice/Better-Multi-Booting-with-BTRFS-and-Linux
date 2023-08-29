#!/bin/bash

# Tested and worked.

# this script makes the folders to be shared between your distros
# These folders are the mount points for the newly created BTRFS subvolumes


# var array of folder names
declare -ar folders=("data" "dotfiles" "programs" "tardis")
# var string path of data folder
declare -r mountPoint="/mnt/"

# Add a section which makes the folder in /mnt/data

# cd to home/user,
# if it has Documents folder etc, and they are empty
# remove them
# Make a symlink pointing at /mnt/data/Documents, etc

# cd into home/$USER

# iterate array
for folder in "${folders[@]}"
  do
    echo -e "Beginning work on ${folder}"
    # if folder does not exist at /mnt make it
    if [[ ! -d $mountPoint$folder ]]
      then
        echo -e "creating $mountPoint${folder}\n"
        #   remove EMPTY folder
        sudo mkdir -p $mountPoint$folder
        sudo chown 1000:1000 $mountPoint$folder
    else
      echo -e "${mountPoint}${folder} already exists."
    fi
done

