## Overview of Sharing Files and Application between Multiple Distros on a Single BTRFS Partition

Assumptions:
- There is only one user on the system. Additional users will require additional configuration, which is not covered here.

**Subvolume Mount Table:**

| subvolume | mount point | owner |
|-----|------|-------|
| @data | /mnt/data | root |
| @dotfiles |  /mnt/dotfiles | $USER |
| @programs | /mnt/programs | root |
| @tardis |  /mnt/tardis | $USER |



# Purpose of each subvolume

**@data:**

for Documents, Downloads, and all such folders normally found in /home/$USER excepting Desktop.

**@dotfiles:**

dot and rc configuration files that you want to have in common for all distros. .bash_aliases might fall into this category.

**@programs:**

Add-on applications you want to use in all distros. 

**@tardis:**

For personal memories and such going back several decades. It's my time travel directory. Feel free to steal my idea, or not. 


# Overview of Procedure

Each subvolume has a document dedicated to it. This document gives a high level overview.

**Do First:**
- Create new BTRFS subvolumes
- @data
- @dotfiles
- @programs
- @tardis


**Do in each distro:**
- Create mountpoints for the subvolumes
- Modify fstab to mount the subvolumes


**Sharing Applications:**\
It is possible to share some applications between distros in order to save drive space.  
Many .deb java runtime applications can be run from here, as can flatpaks. It doesn't work for snaps.
.debs will only need to be installed one time. You can then call them from any distro. Flatpak will need
to be configured especially for this (easy) and applications will need to installed independently in each distro
from which you want to use it. Flatpak will make links rather than make duplicate files.

**Sharing Dotfiles**\
Dotfiles are your system configuration files such as .bash_aliases

Copy your dotfiles to @dotfiles and mount from each distro. Then source the files in your shell rc file.

It's really easy to make this a git repo so you can track changes and backup your dotfiles elsewhere.

**Sharing Personal Files**\
This is the easiest one. Basically you just copy your files to @tardis and then mount it from each distro.

**Sharing Home Subdirectories**\
This requires quite a few steps. 

Basically you make new Documents, Downloads, etc, directories in the @data subvolume and then do a bunch of repetitive shell tasks
in each distro. I have shell scripts which will make it easier and faster. Or you can do it manually, which isn't
difficult, but is time-consuming.









