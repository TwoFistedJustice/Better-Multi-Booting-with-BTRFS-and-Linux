#!/bin/bash
#rename-btrfs-subvolome.sh
# usage: ./rename-btrfs-subvolome.sh @ @manjaro
# This script does NOT work on the currently booted distro.
# It runs from your current distro to change the subvolume names for other distos
# If you somehow succeed in changing your current distro's subvolume name bad things can happen.
# It mounts the BTRFS root subvolume
# Then it looks for the subvolume name you pass as the first argument
# If it finds it, it renames it to whatever you passed as the second argument.
# it creates the folder /mnt/btrfsroot and later removes it

# check number of args and display usage if wrong
if (( $# != 2 ))
  then
    echo "usage: $0 [ old-subvolume-name ] new-subvolume-name"
    exit 1;
fi

declare -r mountPoint="/mnt/btrfsroot/"
declare -r device=$(findmnt -vno SOURCE /home/)

#check if mount point exists
#if it doesn't exist, create it
if [[  ! -d $mountPoint  ]]
  then
    echo -e "Making $mountPoint"
    sudo mkdir -p $mountPoint
fi


# mount btrfs-root
# change directory to mount point
sudo mount -o subvolid=5 $device $mountPoint
echo -e "Changing directory to $mountPoint"
pushd $mountPoint

#rename subv $1 to $2
if [[ -d $1 ]]
  then
    sudo mv $1 $2
  else
    echo -e "Did not find directory: $mountPoint$1"
fi

# unmount btrfs root
umount $mountPoint

# remove mount point
sudo rmdir $mountPoint
echo -e "Returning to original directory"
popd