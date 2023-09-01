# Better Multi-Booting with BTRFS and Linux

This is a new (as of late 2023) paradigm for configuring a multi-boot Linux-only system. This was 
developed and refined within the threads of [Kubuntu Forums](https://www.kubuntuforums.net/forum/general/miscellaneous/btrfs) discussions.

The benefits are improved hard disc space allocation and cross-distro file and application access.
It will allow you to share files and applications across multiple
Linux distros on the same BTRFS partition.

This repo is divided into docs and scripts.

Docs explain the procedures to manually configure your system. The scripts do some of the work automatically 
and may require some additional configuration by the user.

No warranty is promised or provided. 



## Sections
- [Multi-booting linux from one BTRFS partition](/docs/multi-boot-from-one-partition.md#multi-booting-linux-from-a-single-btrfs-partition)
- Sharing between distros
- [Shell scripts to help in setting up the above](/scripts/)

### Sharing Between Distros Section TOC
The optimal order of reading these docs ( according to me )
1. [Overview](docs/sharing-files-and-applications-overview.md)
2. [Initial Setup](docs/sharing-files-and-applications-initial-setup.md)
3. [Sharing dotfiles](docs/sharing-dotfiles.md)
4. [Sharing files](docs/sharing-files.md)
5. [Sharing home subdirectories](docs/sharing-home-subdirectories.md)
6. [Sharing applications](docs/sharing-files-and-applications-overview.md)



### Scripts

Bash scripts are provided in order to help with some of the configuration. I have included scripts I
developed to help with other aspects of configuration which are unrelated to BTRFS.

**file-sharing**
These help with setting up file and application sharing between distros.

**multi-boot-setup**
These help with the basic configuration of BTRFS for multi-booting from a single subvolume.

**networking**
These help with setting up routing



### Multi-Boot Bash Scripts
**Multi-Boot Setup Run Order:**
- rename-btrfs-subvolume.sh


**rename-btrfs-subvolumes.sh**
After you do the initial setup to enable partition sharing and have installed another distro, you 
can use this script to rename subvolumes. You must run it from a distro other than the one you whose
subvolumes you wish to change.


### File-Sharing Bash Scripts
**home-reconfigure.sh**
Before running you must configure fstab to mount @data to /mnt/data

**File Sharing Setup Run Order:**
- subvolumes-create-mountpoints.sh
- subvolumes-create.sh
- home-dir-reconfigure.sh
- home-xdg-reconfigure.sh


### Networking Bash Scripts
**make-ssh-alias**
This is an interactive script that quickly adds an entry to ~/.ssh/config to speed up your host to host ssh connections.

**make-static-ip**
This is an interactive script that quickly sets your machine up with a static ip.