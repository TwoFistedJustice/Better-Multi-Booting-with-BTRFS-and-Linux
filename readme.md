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

Subjects you will have learned something about with successful completion:
- btrfs file system
- partition management
- subvolumes
- root privilges
- grub boot manager
- drive mounting
- file permissions

What this does NOT cover
- anything to do with MS Windows or Mac
- refind boot manager
- making a separate grub partition (advanced)
- LVM (Logical Volume Management)
- Drive encryption

High Level Overview of Phases
1. Partition Drive
2. Install primary OS (recommend ubuntu variant)
3. Rename subvolumes and configure primary OS
4. Install Second OS (any Linux distro)
5. Rename subvolumes and configure secondary OS
6. Boot into and configure primary OS (again)

What you will need:
A bootable USB (recommend Etcher on Linux,  Rufus on Windows) with Kubuntu LTS
An empty SSD or hard drive, preferably one that never had Windows installed on it (Windows leaves things behind...).


Some common terminal commands you will use:
When I say "update grub" I mean open a terminal and type in the following commands:
sudo grub-mkconfig
sudo update-grub

Renaming files use the move command with sudo.
sudo mv oldname newname

Making a backup copy - use the copy command and a tilde:
sudo cp filename filename~


Phase 1 - Drive Partitioning -- A very sparse overview

You will be using Manual partitioning throughout. You will NOT be formatting. Thou shalt not format!
Set up your drive as follows (suggested)

I suggest using Gparted on a bootable USB. You will configure the partition table, sda1 (EFI), and sda2 (swap).

sda3 (btrfs) will be configured by the Kubuntu installer. So you can leave it for the next phase.


| Drive Designation | Filesystem Type | Size | name | label |  
|------------------ | ----------------|-----| ------|----- | 
| sda  | GPT partition table | - | - | - | 
| sda1 | FAT32 | 35 -550 MB | ESP System Partition | EFI
| sda2 | swap | 1.5x RAM | swap | swap 
| sda3 | btrfs | remainder | / | /


Phase 2 - Install primary OS (assumes: Kubuntu LTS xx.04 )

You will need your Kubuntu live USB. Choose "try Kubuntu"
Configure your wifi network and bluetooth pointer in the test distro. Your settings will be transferred to the installer and your final installation. It's also easier than doing it in the installer interface.

Install to sda3
Make sure to choose "/" as mount point. The selection box is placed below and easy to miss.

___________________________________________
Phase 3 Configure the primary OS ( assumes Kubuntu )

First decide what you are going to name your subvolumes. I make it simple by using @ku and @ku_home. I will use those names here, but you can use whatever you want. 

This is easiest using the same Kubuntu USB you used to install. Boot into the "Try" version.

You can do these steps either in terminal (Konsole) or using the file explorer (Dolphin).

Personally I find the file explorer easier and faster for this. In any event, we will use the Dolphin file explorer and the text editor Kate for most steps.


Part A - Rename btrfs subvolumes
Open Dolphin, find your main drive and use the right click menu to open a terminal there.

Find @ and @home with your terminal. Then execute the following commands:

sudo mv @ @ku 
sudo mv @home @ku_home 



Part B - Modify fstab
location: /etc/fstab
fstab is the file where Linux stores the "File System TABle". It's an important file and if you don't know it, you should make it a point to learn about it in the near future.

Find fstab in your file explorer. Make a backup copy by whatever means you prefer. Right click on the original and select "open with Kate".

Change all instances of @ => @ku
Change all instances of @home => @ku_home

Save the file and exit.



Part C - Modify grub.cfg ( fun times ahead, you'll be doing this again next step but with an identically named file somewhere else)
location: /boot/grub/grub.cfg
Find it with the file explorer Dolphin. Make a backup copy. Right click on the original and select "open with Kate".
It's a long file. Take a few minutes to get familiar with the various sections. It's okay if you don't understand it. Just note where the sections for starters.

The part you will need to be at least a little bit familiar with is the section "10_linux". This is where all the auto-generated grub menu options are kept.
We are going to use Kate's Find & Replace feature. Weird thing: Kate has TWO similar looking F&R features.

DO NOT USE:  
 - Edit => Replace (NO)
 - CTRL-F  (NO)

It lacks the features we need

DO USE: 
- Go to the BOTTOM of the window and choose "Search and Replace" (YES)

In the "Find" bar enter @ and click "Search"
You'll see a bunch of lines that look like:

linux	/@/boot/vmlinuz-5.19.0-46-generic root=UUID=73ffa900-dca2-47f2-9e0b-f8c1942ef918 ro rootflags=subvol=@  quiet splash $vt_handoff

Note that there is an "@" at the beginning and "subvol=@" one at the end. These will be handled a little differently.

We need to change all the @ to @ku. So enter @ku in the "Replace" field and click "Replace"
The lines should look like this:
linux	/@ke/boot/vmlinuz-5.19.0-46-generic root=UUID=73ffa900-dca2-47f2-9e0b-f8c1942ef918 ro rootflags=subvol=@ku  quiet splash $vt_handoff

We are not done. The world will end in dragonfire if we don't add a forward slash to all the subvol fields. So:
In the "Find" bar enter "subvol=" 
In the "Replace" bar enter "subvol=/" and click Replace

It should look like:

linux	/@ke/boot/vmlinuz-5.19.0-46-generic root=UUID=73ffa900-dca2-47f2-9e0b-f8c1942ef918 ro rootflags=subvol=/@ku  quiet splash $vt_handoff

Manually look over all the changed lines and make sure everything looks as it should.

Save and exit.



Part D - Modify grub.cfg ( told you )
location: /boot/efi/EFI/ubuntu/grub.cfg
This step is to modify the grub $prefix variable. If you don't do this, you will get stuck at the grub prompt. That would be bad. Also, this step doesn't work the same for every distro (Kali for example). 

We will use Krusader file explorer. It is not installed by default. So open the package manager Muon and install Krusader.

Open Krusader and click through it's first time start up routine. Acdept everytying then go to Tools >> Start Root Mode Krusader and repeat the start up routine.

Now navigate to /boot/efi/EFI/ubuntu/ and select grub.cfg

At the bottom of the window click "f4 Edit"

The second line should read:
"set prefix=($root)'/@/boot/grub'"

Change @ => @ku and save the file. 

Close Krusader.


___________________________________________

Phase 4 Install and Configure Second OS





Phase 5 Rename subvolumes and configure secondary OS
I will describe Kali Linux. Other distros should be similar.
You can configure your second OS either with your Kubuntu installer as before or you can use your actual Kubuntu installation.

I will describe the steps as from your installed OS since it is different than using the bootable USB.

Phase 6: Boot into and configure primary OS (again)










