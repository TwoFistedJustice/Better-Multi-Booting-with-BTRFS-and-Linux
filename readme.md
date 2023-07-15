Better Multi-Booting with BTRFS and Linux

This is based on:
- [More BTRFS fun: Multibooting to subvolumes on the same partition](https://www.kubuntuforums.net/forum/general/miscellaneous/btrfs/54261-more-btrfs-fun-multibooting-to-subvolumes-on-the-same-partition?highlight=multibooting+btrfs) by [@oshunluvr](https://www.kubuntuforums.net/member/35692-oshunluvr)
- [Need help setting up multi-boot with btrfs](https://www.kubuntuforums.net/forum/general/kubuntu-catchall/671909-solved-need-help-setting-up-multi-boot-with-btrfs) by [@twoFistedJustice](https://www.kubuntuforums.net/member/32889-twofistedjustice)


| Difficulty Level: | Intermediate
|----- | -----|


This tutorial assumes the following:
- you are comfortable working in the command line
- you know how to make a bootable USB
- you can fix your system when you break it ( probability high if this is your first attempt or you are tired )
- Your primary OS will be Kubuntu LTS ( whatever the latest version is - 22.04 as of July 14th, 2023 )
- You can at least muddle through drive partitioning on your own (it will NOT be explained in detail here)
- You will be using EFI and not MBR (if you don't know what these are, then you will be using EFI by default)

Subjects you will have learned about with a successful completion:
- btrfs file system
- partition management
- subvolumes
- root privilges
- grub boot manager
- drive mounting
- file permissions

What this does NOT cover
- anything to do with MS Windows
- anything to do with Mac
- refind boot manager
- making a separate grub partition (advanced)
- LVM (Logical Volume Management)
- Drive encryption

High Level Overview
1. Partition Drive
2. Install primary OS (recommend ubuntu variant)
3. Rename subvolumes and configure
4. Install Second OS (any Linux distro)
5. Rename subvolumes and configure
6. Boot into primary OS and configure (again)

What you will need:
A bootable USB (recommend Etcher on Linux,  Rufus on Windows) with Kubuntu LTS
An empty SSD or hard drive, preferably one that never had Windows installed on it (Windows leaves things behind...).



Phase 1 - Drive Partitioning -- A very sparse overview

You will be using Manual partitioning throughout. You will NOT be formatting. Thou shalt not format!



























