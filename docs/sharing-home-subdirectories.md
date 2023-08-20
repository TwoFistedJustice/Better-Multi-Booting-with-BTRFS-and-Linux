# Sharing Home Subdirectories
###(between Multiple Distros on a Single BTRFS Partition)


Assumptions:
- There is only one user on the system. Additional users will require additional configuration, which is not covered here.

We will be working with the @data subvolume

**Subvolume Mount Table:**

| subvolume | mount point | owner |
|-----|------|-------|
| @data | /mnt/data | root |

Before beginning, make sure your fstab has mounted the appropriate subvolume.

**Benefit:** \
Your documents, downloads, music, etc will be available from all distros.

## Sharing /home/$USER/Documents etc

| Difficulty Level: | Easy
|----- | -----|

The goal is to have all the folders in /home/user except Desktop shared between all distros. You can share Desktop too with minor changes to this tutorial. 
 I chose not to do so I could have different shortcuts on the different desktops according to how I use that distro.

The process is simple.

First make sure in fstab that you have mounted @data to /mnt/data 

Create folders with the same names in /mnt/data/

Move or copy all the data in the original folders to their replacements

Update the XDG config file and source the updated file. I only show it for Downloads and Documents. Substitute the respective folder names for the rest.  
**Location:** `~/.config/user-dirs.dirs` 
```shell
xdg-user-dirs-update --set DOWNLOADS /mnt/data/Downloads
xdg-user-dirs-update --set DOCUMENTS /mnt/data/Documents
xdg-user-dirs-update;
source ${HOME}/.config/user-dirs.dirs;
```

Rename the original folders by appending ".d" to the end. This is in case you mess up, so you don't accidentally delete stuff that you want to keep.

Create symlinks in your home folder to the new folders
**Location:** ~/$USER 

```shell
sudo ln --symbolic  path/to/folder linkname
sudo ln -s  /mnt/data/Downloads/ Downloads
```

Confirm everything works and looks as it should and that the original renamed folders are empty, then delete them.


### The Script
the file `home-reconfigure.sh` quickly reconfigures XDG-user-dirs.dirs and replaces the folders in ~/ with links.




