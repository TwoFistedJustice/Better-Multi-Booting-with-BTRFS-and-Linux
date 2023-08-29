Configuring XDG for Sharing of Home/ sub-folders

| Difficulty Level: | Easy
|----- | -----|

Script:
home-xdg-reconfigure.sh will do this for you.


Update the XDG config file and source the updated file. I only show it for Downloads and Documents. Substitute the respective folder names for the rest.  
**Location:** `~/.config/user-dirs.dirs`
```shell
xdg-user-dirs-update --set DOWNLOADS /mnt/data/Downloads
xdg-user-dirs-update --set DOCUMENTS /mnt/data/Documents
xdg-user-dirs-update --set PUBLICSHARE /mnt/data/Public
... do for all folders
xdg-user-dirs-update;
source ${HOME}/.config/user-dirs.dirs;
```
