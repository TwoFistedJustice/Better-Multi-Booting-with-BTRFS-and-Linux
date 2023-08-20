## Sharing Dotfiles 
### (between Multiple Distros on a Single BTRFS Partition)

Assumptions:
- There is only one user on the system. Additional users will require additional configuration, which is not covered here.

We will be working with the @dotfiles subvolume

**Subvolume Mount Table:**

| subvolume | mount point | owner |
|-----|------|-------|
| @dotfiles |  /mnt/dotfiles | $USER |

Before beginning, make sure your fstab has mounted the appropriate subvolume.

**Benefit:** \
You will have your shell aliases and functions available in all your distros from a single location. When you make changes it will affect
all distros without further action.



This is NOT where you will keep your .bashrc or .zshrc or .[shell]rc file. That belongs in your /home/$USER directory.

Make a file called 
`.sourcesrc`

This file will contain references to each of the other files in this directory that you would normally 
reference from your shellrc file. Add a reference to this file in the shellrc file inside your home folder.


Follow this format for each file you want to include

-`f` checks if it exists and is a regular file \
`source` tells it to use the file \
```shell
if [ -f mnt/dotfiles/.bash_aliases ]; then
source mnt/dotfiles/.bash_aliases
fi
```


