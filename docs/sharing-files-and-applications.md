# Sharing Files and Application between Multiple Distros on a Single BTRFS Partition

Assumptions:
- There is only one user on the system. Additional users will require additional configuration, which is not covered here.

Add following subvolumes to main system partition ( sda3 for me )

@data
@dotfiles
@programs
@tardis




**Subvolume Mount Table:**

| subvolume | mount point | owner |
|-----|------|-------|
| @data | /mnt/data | root |
| @dotfiles |  /mnt/dotfiles | $USER |
| @programs | /mnt/programs | root |
| @tardis |  /mnt/tardis | $USER |


# Purpose of each subvolume

@data:

for Documents, Downloads, and all such folders normally found in /home/$USER excepting Desktop.

@dotfiles:

dot and rc configuration files that you want to have in common for all distros. .bash_aliases might fall into this category.

@programs:

Add-on applications you want to use in all distros. 
Many .deb java runtime applications can be run from here, as can flatpaks. Doesn't work for snaps.

@tardis:

where I keep my personal memories and such going back several decades. It's my time travel directory. Feel free to steal my idea, or not. 



## Sharing /home/$USER/Documents etc

| Difficulty Level: | Easy
|----- | -----|

The goal is to have all the folders in /home/user except Desktop shared between all distros. You can share Desktop too with minor changes to this tutorial. 
 I chose not to do so I could have different shortcuts on the different desktops according to how I use that distro.

The process is simple.

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

Rename the original folders by appending ".d" to the end. This is in case you mess up, you don't accidentally delete stuff.

Create symlinks in your home folder to the new folders
**Location:** ~/$USER 

```shell
sudo ln --symbolic  path/to/file linkname
sudo ln -s  /mnt/data/Downloads/ Downloads
```

Confirm everything works and looks as it should and that the original renamed folders are empty, then delete them.







