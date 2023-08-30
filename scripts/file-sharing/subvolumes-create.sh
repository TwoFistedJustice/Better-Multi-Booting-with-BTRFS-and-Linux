#!/bin/bash

## THIS IS UNTESTED
## THIS IS UNTESTED
## THIS IS UNTESTED
## THIS IS UNTESTED

# declare an array of subvolume names
declare -ar subvolumes=("@data" "@dotfiles" "@programs" "@tardis")

# get the drive device designation
declare -r device=$(findmnt -vno SOURCE /home/)
declare -r mountPoint="/mnt/btrfsroot"

# make mount point for btrf root
sudo mkdir -p $mountPoint



# mount root btrfs
sudo mount -o subvolid=5 $device $mountPoint

# cd into btrfs root
cd $mountPoint

# iterate over array
for subvolume in "${subvolumes[@]}"
 do
    #check if dir exists
    if [[ ! -d $subvolume ]]
      then
        # make subv for each
        sudo btrfs subv create $subvolume
        if [[ -d $subvolume]]
          then
            echo -e "subvolume ${subvolume} created."
            else
              echo -e "!!! ERROR: Something went wrong. ${subvolume} was not created !!!"
        fi

        else
          echo -e "${subvolume} already exists. Skipping."
    fi
 done
# unmount btrfs root
sudo umount $mountPoint






