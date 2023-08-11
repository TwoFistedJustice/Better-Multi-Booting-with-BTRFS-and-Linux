#!/bin/bash
# This file reconfigures the folders Documents, Downloads, etc to a central place where all distros can access them.
#  It must be run for each distro and assumes you have only one user per machine. Additional users require you to
#  modify the script.
# Be sure to empty the folders PRIOR to running this script
# if the folders are not empty, the script will fail (by design)
# this will work on the current user only


# var array of folder names
declare -ar folders=("Documents" "Downloads" "Music" "Pictures" "Public" "Templates" "Videos")
# var string path of data folder
declare -r mountPoint="/mnt/data"

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
  sudo ln -s "${mountPoint}/${folder}" $folder
  else
  echo -e "${folder} not found."
#   mkdir $folder
# make symlink of same name pointing to /mnt/data
fi
done
