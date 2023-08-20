#Better Multi-Booting with BTRFS and Linux

This is a new (as of late 2023) paradigm for configuring a multi-boot Linux-only system. This was developed and refined within the threads of Kubuntu Forums discussions.

The benefits are improved hard disc space allocation and cross-distro file and application access. It will allow you to share files and applications across multiple
Linux distros on the same BTRFS partition.

This repo is divided into docs and scripts.

Docs explain the procedures to manually configure your system. The scripts do some of the work automatically and may require some additional configuration by the user.

No warranty is promised or provided. 



## Sections
- [Multi-booting linux from one BTRFS partition](/docs/multi-boot-from-one-partition.md#multi-booting-linux-from-a-single-btrfs-partition)
- Sharing between distros
- Shell scripts to help in setting up the above


### Scripts
**rename-btrfs-subvolumes.sh**
After you do the initial setup to enable partition sharing and have installed another distro, you 
can use this script to rename subvolumes. You must run it from a distro other than the one you whose
subvolumes you wish to change.

**home-reconfigure.sh**
Before running you must configure fstab to mount @data to /mnt/data

