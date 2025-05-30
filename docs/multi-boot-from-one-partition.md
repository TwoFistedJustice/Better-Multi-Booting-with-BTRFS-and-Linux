# Multi-Booting-Linux-From-a-Single-BTRFS-Partition

This is based on:
- [More BTRFS fun: Multibooting to subvolumes on the same partition](https://www.kubuntuforums.net/forum/general/miscellaneous/btrfs/54261-more-btrfs-fun-multibooting-to-subvolumes-on-the-same-partition?highlight=multibooting+btrfs "Origin post on multi-booting BTRFS from a single partition on Kubuntu Forums") by [@oshunluvr](https://www.kubuntuforums.net/member/35692-oshunluvr "Kubuntu Forums user page for oshunluvr")
- [Need help setting up multi-boot with btrfs](https://www.kubuntuforums.net/forum/general/kubuntu-catchall/671909-solved-need-help-setting-up-multi-boot-with-btrfs "Post solving EFI related issues when multi-booting from a single BTRFS partition, on Kubuntu Forums") by [@TwoFistedJustice](https://www.kubuntuforums.net/member/32889-twofistedjustice "Kubuntu Forums user page for TwoFistedJustice")

This tutorial is best for those who have yet to achieve advanced command line skills. If you are strong in the Linux, you can follow oshunluvr's post above and then do Phase 3-E & 5-J below. Please also browse the troubleshooting sections ( 7 & 8 ) at the end.


| Difficulty Level: | Intermediate
|----- | -----|

>DISCLAIMER:
> This is best done a on a drive which contains no data. If you do it on a drive with data make sure to back up anything important before beginning. Though It did work for me, I do not guarantee that this will work for you.

**Overview From Orbit:**

You can install as many versions of Linux you want as long as they support btrfs. Most installers will usually try to install them to `@` and `@home`
subvolumes. Some won't. You may need to rename the subvolumes to something else. In fact, you should plan to rename them to just about anything else
instead of `@` and `@home`. You'll want to leave those two free for installers to use. Also, if you don't, then one day you might unintentionally
overwrite your system. oops.

There are a lot of steps. And you should be comfortable working in the command line before beginning. If you screw up, it's probably fixable. Probably.

**This tutorial assumes the following:**
- you are comfortable working in the command line
- you know how to make a bootable USB
- you can fix your system when you break it ( probability high if this is your first attempt or you are tired )
- Your primary OS will be Kubuntu LTS ( whatever the latest version is - 22.04 as of July 14th, 2023 )
- You can at least muddle through drive partitioning on your own (it will NOT be explained in detail here)
- You will be using EFI and not MBR (if you don't know what these are, then you will be using EFI by default)

**Subjects you will have learned something about with successful completion:**
- btrfs file system
- partition management
- subvolumes
- root privileges
- grub boot manager
- drive mounting
- file permissions

**What this does _NOT_ cover**
- anything to do with MS Windows or Mac
- refind boot manager
- making a separate grub partition (advanced)
- LVM (Logical Volume Management)
- Drive encryption

**High Level Overview of Phases**
1. [Partition Drive](#phase-1---partition-drive)
2. [Install primary OS](#phase-2---install-primary-os) (recommend ubuntu variant)
3. [Rename subvolumes and configure primary OS](#phase-3---configure-primary-os)
4. [Install Secondary OS](#phase-4---install-secondary-os) (any Linux distro)
5. [Rename subvolumes and configure secondary OS](#phase-5---configure-secondary-os)
6. [Boot into and configure primary OS (again)](#phase-6---configure-primary-os-again)
7. [Troubleshoot fstab](#phase-7---troubleshoot-fstab)
8. [Troubleshooting](#phase-8---troubleshooting)

**What you will need:**
- A bootable USB (recommend [Etcher](https://etcher.balena.io/ "official Etcher download page") on Linux,  [Rufus](https://rufus.ie/en/ "Rufus developer website") on Windows) with [Kubuntu LTS](https://kubuntu.org/getkubuntu/ "Official Kubuntu LTS download page")
- An empty SSD or hard drive, preferably one that never had Windows installed on it ( Windows leaves _Things_ behind... )

You should make a writable partition on the USB drive. Ignore all the tutorials. Just use a partition manager to delete the "unformatted" partition 
at the end, and create a new ext4 partition in its place. You may have to modify its permissions using `chown` and `chmod`.


## Common terminal commands and syntax we will use:

Note: These are not ALL the terminal commands we need. You should already have basic bash literacy before proceeding.

- Whenever I use the syntax `x => y` what I mean is "change x to y".


- " ==> Update grub " means open a terminal and type in the following commands:
```shell
sudo grub-mkconfig
sudo update-grub
```
- Renaming files

Use the move command with sudo.
```shell
sudo mv oldname newname
```

- Making a backup copy

Use the copy command and add a tilde to the copy name:
```shell
sudo cp filename filename~
```

- To inspect the contents of a file:
```shell
cat /filepath/filename
```
to add syntax highlighting: ( will need to install )
```shell
batcat /filepath/filename
```

### Phase 1 - Partition Drive
**-- A very sparse overview**

You will be using Manual partitioning throughout. You will NOT be formatting. _Thou shalt not format!_

Set up your drive as follows (suggested)

I suggest using [Gparted](https://gparted.org/ "Gparted Website") on a bootable USB. You will configure
- GUID Partition Table ( GPT )
- sda1 ( EFI )
- sda2 ( swap )

sda3 (btrfs) will be configured by the Kubuntu installer. So you can leave it for the next phase.


| Drive Designation | Filesystem Type | Size | name | label |  
|------------------ | :----------------|:------:| :------:|:-----: | 
| sda  | GPT partition table | - | - | - | 
| sda1 | FAT32 | 100 -550 MiB | EFI System Partition | EFI
| sda2 | swap | 1.5x *see note | swap | swap
| sda3 | btrfs | remainder | / | /

**Note:** swap drive should be either:
- 1.5x system RAM
- 1.5x expected maximum RAM utilization

How do you know which? Experience mostly. If your computer has 8gb ram, then 12gb is probably safe. But if you have 32gb of RAM, then 48gb is probably overkill, unless you are a power user.

### Phase 2 - Install Primary OS
**-- assumes: Kubuntu LTS xx.04**

**DO**
- Install Kubuntu to sda3 **( YES )**
- Choose " / " as mount point. The selection box is placed below and easy to miss.

**DO NOT**
- let the installer automatically configure your drive **( NO )**

Use your Kubuntu live USB to boot up your system. Choose "try Kubuntu".

Configure your wifi network and bluetooth pointer in the test distro. Your settings will be transferred to the installer and your final installation. It's also easier than doing it in the installer interface.

At the entrance to the partitioning section, choose "Manual" or "Something else" or the equivalent.

Choose the btrfs file system and use up the unallocated portion of the drive. Choose "/" as mount point (see Do above). Fill in the all the boxes that need filling and install.

### Phase 3 - Configure primary OS
**-- assumes _Kubuntu_**

You can do these steps either in terminal (Konsole) or using the file explorer (Dolphin).

We will here use the Dolphin file explorer and the text editor Kate for most steps. To open Dolphin with a keyboard shortcut hit `META + E` (META aka - the Windows Key). If you prefer the terminal go ahead and do it that way.

Note: You will be repeating these steps, excepting D and E with your secondary distro in Phase 5.

**DO NOT DO:**
- Part D as part of [Phase 5](#phase-5---configure-secondary-os) **( NO )**
- Part E as part of [Phase 5](#phase-5---configure-secondary-os) **( NO )**

A - [Decide What to call your subvolumes](#step-a-decide-what-you-will-call-your-subvolumes) \
B - [Modify fstab](#step-b-modify-fstab) \
C - [Modify grub.cfg](#step-c---modify-grubcfg) \
D - [Install Krusader](#step-d-install-krusader) \
E - [Modify EFI grub.cfg](#step-3e---modify-grubcfg--told-you-) \
F - [Rename btrfs subvolumes](#step-f---rename-btrfs-subvolumes) \
G - [Update grub](#step-g---update-grub)

#### Step A Decide what you will call your subvolumes
I make it simple by using @ku and @ku_home. I will use those names here, but you can use whatever you want.

#### Step B Modify fstab
**Location:** `/etc/fstab`

fstab is the file where Linux stores the "**F**ile **S**ystem **TAB**le". It's an important file and if you don't know it, you should make it a point to learn about it in the near future.

Find fstab in your file explorer. Make a backup copy by whatever means you prefer. Right click on the original and select "Open with Kate".

- Change all instances of `@ => @ku`
- Change all instances of `@home => @ku_home`

Save the file and exit.

#### Step C - Modify grub.cfg
- Modify grub.cfg ( fun times ahead, you'll be doing this again later but with an identically named file somewhere else)

  **Location:** `@ku/boot/grub/grub.cfg`

Find it with the file explorer Dolphin. Make a backup copy. Right click on the original and select "Open with Kate".
It's a long file. Take a few minutes to get familiar with the various sections. It's okay if you don't understand it. Just note where the sections for starters.

The part you will need to be most familiar with is the section "10_linux". This is where all the auto-generated grub menu options are kept.
We are going to use Kate's Find & Replace feature. Weird thing: Kate has TWO similar looking F&R features.

**DO:**
- Go to the BOTTOM of the window and choose "Search and Replace" **( YES )**

**DO NOT:**
- Edit => Replace **( NO )**
- CTRL+ F  **( NO )**

They lack the features we need.

In the "Find" bar enter @ and click "Search"
You'll see a bunch of lines that look like:

`linux	/@/boot/vmlinuz-5.19.0-46-generic root=UUID=73ffa900-dca2-47f2-9e0b-f8c1942ef918 ro rootflags=subvol=@  quiet splash $vt_handoff`

Note that there is an `@` at the beginning and `subvol=@` at the end. These will be handled a little differently.

We need to change all the @ to @ku. So enter @ku in the "Replace" field and click "Replace Checked"
The lines should look like this:

`linux	/@ku/boot/vmlinuz-5.19.0-46-generic root=UUID=73ffa900-dca2-47f2-9e0b-f8c1942ef918 ro rootflags=subvol=@ku  quiet splash $vt_handoff`

We are not done. The world will end in dragonfire if we don't add a forward slash to all the subvol fields. So:

- In the "Find" bar enter `subvol=`
- In the "Replace" bar enter `subvol=/` and click Replace

It should look like:

`linux	/@ku/boot/vmlinuz-5.19.0-46-generic root=UUID=73ffa900-dca2-47f2-9e0b-f8c1942ef918 ro rootflags=subvol=/@ku  quiet splash $vt_handoff`

Manually look over all the changed lines and make sure everything looks as it should.

Save and exit.

#### Step 3D Install Krusader

(not for Phase 5)

In the next step we will use **Krusader** file explorer. It is not installed by default. So open the package manager **Muon**, click "Check for Updates", then
install Krusader.

#### Step 3E - Modify grub.cfg ( told you )
**Location:** `/boot/efi/EFI/ubuntu/grub.cfg`

(not for Phase 5)

This step is to modify the grub `$prefix` variable in your main OS. If you don't do this, you will get stuck at the grub prompt, which will bring about a zombie apocalypse. Also, this step doesn't work the same for every distro (Kali for example).

Open Krusader and click through it's first time start up routine. Accept everything then go to `Tools >> Start Root Mode Krusader` and repeat the start up routine.

Now navigate to `/boot/efi/EFI/ubuntu/` and select `grub.cfg`

At the bottom of the window click `f4 Edit`

The second line should read:
`set prefix=($root)'/@/boot/grub'`

Change `@ => @ku` and save the file.

Close Krusader.

Congratulations! Your computer is now BROKEN!!! It won't start!!! MWAHAHA!!! But we're going to fix it in the next step because I'm a pretty easy-going super-villain.

#### Step F - Rename btrfs subvolumes
Boot into the computer using the same Kubuntu USB stick you used to install. Choose the "Try" version.

Open Dolphin, find your main drive and use the right click menu to open a terminal there.

Find @ and @home with your terminal. Then execute the following commands:

- `sudo mv @ @ku`
- `sudo mv @home @ku_home`

Now it's fixed. Reboot and remove the USB stick.

#### Step G - Update Grub
Open a terminal ==> Update grub.


### Phase 4 - Install Secondary OS
I will only give some DOs and DO NOTs here as each distro is different.

**DO:**
- Install to the same btrfs partition as before. **( YES )**

**DO NOT:**

- Change your drive partitions **( NO )**
- Choose automatic anything **( NO )**


### Phase 5 - Configure Secondary OS

>Note:
> Much of this can be done by mounting btrfs root from Kubuntu
> See Alternative Method at the end of the document for how to do this.
> This method is faster, but also creates more opportunity to break things
> in your system.

Overview of Phase 5:

Firstly, decide what you are going to call your new subvolumes. I installed Kali on my system so I chose @kali. You might use @mint or @manjaro, etc.

These steps are very similar to what you did previously so I will only detail the parts that are different. For the most part you will do everything the same way.
This can be done from within the installed version of Kubuntu (intermediate) which I do not cover here or from the Kubuntu Live USB (easy).

After we are finished Kubuntu will "own" grub and boot the computer. ( look up "boot up vs start up" )

**Important Notes:**
1. In Phase 5 Steps C and D are reversed from their order in Phase 3

2. To edit /boot/grub/grub.cfg in your secondary distro you will use Root Mode Krusader's **F4 Edit**. It has a similar Find & Replace to Kate. Use **CTRL+R** to open it.

3. The path to find the subvolumes on the Kubuntu Live USB is:

**Location:** `/media/kubuntu/[UUID]/`

**DO NOT:**
- reconfigure grub $prefix. **( NO )**
- Do Step E **( NO )**

Repeat [Phase 3](#phase-3---configure-primary-os) parts A through G for the new distro. Do NOT do Step E. When are done with that come back to this point.

The steps for the secondary distro are:

A - [Decide What to call your subvolumes](#step-a-decide-what-you-will-call-your-subvolumes) \
B - [Modify fstab](#step-b-modify-fstab) \
C - [Install Krusader](#step-d-install-krusader) \
D - [Modify grub.cfg](#step-c---modify-grubcfg) \
E - [~~Modify EFI grub.cfg~~](#phase-5---configure-secondary-os) \
F - [Rename btrfs subvolumes](#step-f---rename-btrfs-subvolumes) \
G - [Update grub](#step-g---update-grub) \
H - [Copy fstab](#step-5h---copy-fstab) \
I - [Copy a block of code from grub.cfg](#step-5i-copy-a-block-of-code-from-grubcfg) \
J - [Check if grub symlinks are already configured](#step-5j-setting-up-grub-symlinks) \
K - [Configure grub symlinks](#step-5k---creating-the-symlinks-manually)

For the next two steps we are going to copy some data from your secondary OS to your main OS. You will need a way to get it over there. I used a USB stick as file-transfer media.

#### Step 5H - Copy fstab

Start by saving a copy of fstab to your file-transfer media because we may need a piece of information in it at the very end of this long process.

**Location:** /`etc/fstab`


#### Step 5I Copy a block of code from grub.cfg

Now we are going to copy some code out of the secondary OS grub.cfg.

**Location:** `/boot/grub/grub.cfg`

Find the section  `### BEGIN /etc/grub.d/10_linux ### `

copy the first menu entry  from the word "menuentry" to the first closing curly brace. It looks something like this:

``` shell 
menuentry 'Kali GNU/Linux' --class kali --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-73f6525c-0f9c-4a23-a91b-d1b46f5079c8' {
load_video
insmod gzio
if [ x$grub_platform = xxen ]; then insmod xzio; insmod lzopio; fi
insmod part_gpt
insmod btrfs
set root='hd0,gpt3'
if [ x$feature_platform_search_hint = xy ]; then
search --no-floppy --fs-uuid --set=root --hint-bios=hd0,gpt3 --hint-efi=hd0,gpt3 --hint-baremetal=ahci0,gpt3 73f6525c-0f9c-4a23-a91b-d1b46f5079c8
else
search --no-floppy --fs-uuid --set=root 73f6525c-0f9c-4a23-a91b-d1b46f5079c8
fi
echo 'Loading Linux 6.1.0-kali9-amd64 ...'
linux /@/boot/vmlinuz-6.1.0-kali9-amd64 root=UUID=73f6525c-0f9c-4a23-a91b-d1b46f5079c8 ro rootflags=subvol=@ quiet splash
echo 'Loading initial ramdisk ...'
initrd /@/boot/initrd.img-6.1.0-kali9-amd64
}
```

Extract that by whatever means you like to your main distro. ( I pasted it into a text file and moved it via usb stick) and make a second copy of your extracted code in case you break it.

Just a **reminder**: make sure you have a copy of your secondary distro `fstab` file before you log out of it.

#### Step 5J Setting up grub symlinks

Symlink is short for "symbolic link". That's Linux-speak for a shortcut.

The first thing to do is to see if your new distro uses symbolic links when booting grub.
Open up a terminal and go to /boot

**Location:** `/boot`

Run the command:

`ll` (double letter 'l' - the one between 'k' and 'm')

We are looking for four lines with arrow thingies like this:

```shell
 lrwxrwxrwx 1 root root        25 Jun 28 17:59 vmlinuz -> vmlinuz-5.19.0-46-generic
 ```
You want to see
- `initrd.img -> ...`
- `initrd.img.old -> ...`
- `vmlinuz -> ...`
- `vmlinuz.old -> ...`

If those are present then you can skip the rest of this section and move on to Phase 6.

If they are NOT present then you haven't got the symlinks and you need to set them up. This is easy.

In your terminal we need to navigate to your /etc directory and inspect the `kernel-img.conf` file.

**Location:** /etc/kernel-img.conf

cat it out. It should look something like this:

```shell
# Kernel Image management overrides
# See kernel-img.conf(5) for details
do_symlinks = no
do_bootloader = no
```

If do_symlinks is set to no, then open the file with kate and change that no to yes:
`do_symlinks = yes`

Now we add the symbolic links.

The REALLY easy way ( which may not work ) is to update your system. If one of the updates is a new kernel version, then the link ought to be created automatically.


So update your system and recheck the /boot folder for those symlinks. If they weren't created then no big deal. You just need to do it manually. This is easy.

#### Step 5K - Creating the symlinks manually
You need to make FOUR of them. Use your terminal to navigate to the /boot folder

**Location:** `/boot`

We make the symlinks with the `ln` command, with the `-s` switch. It takes two arguments, the first is the name of the file you want to link, and the second is the name you want to give the link.

```shell
sudo ln -s filename linkname
```
If it helps you retain the info better you can also type it as:
```shell
sudo ln --symbolic  filename linkname
```

We will make links to the newest kernel files for booting and the second newest as fallback because sometimes even Linux breaks.

```shell
sudo ln -s kernel-you-want-as-default vmlinuz

sudo ln -s kernel-you-want-as-fallback vmlinuz.old

sudo ln -s initrd-image-you-want-as-default initrd.img

sudo ln -s initrd-image-you-want-as-fallback initrd.img.old
```

Verify that the links are as they should be. If everything looks correct reboot into that same distro. If it starts up you did it right and can move on to Phase 6. You don't need to update grub this time.


### Phase 6 - Configure Primary OS (again)
Reboot into Kubuntu

We need to make the following changes to two of the last four lines of the extracted code. Make sure you have a backup copy before you start.

Firstly, note the "echo" commands. They print messages to the grub bootup screen. Feel free to make them say whatever you find useful or amusing. You can also safely delete them.
The two lines we need to change are the "linux" and "initrd" command lines.

Change the three "@" subvolume names down at the bottom to whatever you intend to name your new distro @ subvolume.

Now we are going to change the file names being used. If we don't do this, our shiny new dual boot system will break the first time the Linux kernel is updated and we may not remember how to fix it. So let's prevent it.

In my sample text the file names are:

- `vmlinuz-6.1.0-kali9-amd64`

- `initrd.img-6.1.0-kali9-amd64`

To get this step right you may have do it a few times because not all distros handle this part the same way. So there may be some trial and error.

If you are in an Ubuntu variant you need to change the file names to:
- `vmlinuz`
- `initrd.img`


You can optionally remove "quiet splash" in the `linux` command which will turn of the splash screen and show you the helpful system start up messages. Being able to see those messages may make your life easier and is recommended.

Double check that everything is correct ( see below for example ) and paste it into the file '40_custom' in your main distro.

**Location:** `/etc/grub.d/40_custom`


**Example of modified grub code:** ( only the last four lines are different )
``` shell 
menuentry 'Kali GNU/Linux' --class kali --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-73f6525c-0f9c-4a23-a91b-d1b46f5079c8' {
load_video
insmod gzio
if [ x$grub_platform = xxen ]; then insmod xzio; insmod lzopio; fi
insmod part_gpt
insmod btrfs
set root='hd0,gpt3'
if [ x$feature_platform_search_hint = xy ]; then
search --no-floppy --fs-uuid --set=root --hint-bios=hd0,gpt3 --hint-efi=hd0,gpt3 --hint-baremetal=ahci0,gpt3 73f6525c-0f9c-4a23-a91b-d1b46f5079c8
else
search --no-floppy --fs-uuid --set=root 73f6525c-0f9c-4a23-a91b-d1b46f5079c8
fi
echo 'I can make it say whatever I want!!!'
linux /@kali/boot/vmlinuz* root=UUID=73f6525c-0f9c-4a23-a91b-d1b46f5079c8 ro rootflags=subvol=/@kali
echo 'MWAHAHA!!!!'
initrd /@kali/boot/initrd.img*
}
```

==> Update grub.

Reboot and make sure your secondary OS shows up in the grub menu.

If it's there, select it and boot it.

If just sends you back to the grub menu OR it's not there at all:
- check your 40_custom code syntax, make corrections, check all the syntax, { braces }, etc.

==> update grub.

If it starts to boot then just hangs with a message of "kernel panic" then it may be how you named your kernel file in 40_custom.

Make sure your symlinks are turned on per Phase 5G and that the symlinks are in /boot.

If it STILL won't boot, you can try a hacky ill-advised method that is at best a temporary fix by taking advantage of [globbing](https://en.wikipedia.org/wiki/Glob_(programming) "Wikipedia page on globbing") ( fancy text manipulation magic ).
by inserting a wildcard character at then end of the symlink name in grub.cfg, which looks like
- `vmlinuz*`
- `initrd.img*`

Or you can use the actual kernel file name, which will only work until the next update.

Remember, after changing your grub files:

==> Update grub.


### Phase 7 - Troubleshoot _fstab_

The last thing to do is to see if the last distro you installed hijacked your swap drive. It's okay if it did. It's easy to fix.

You may have seen a message with a long countdown while starting your main OS to the effect of `startup process /dev/disk/by-uuid/someUUID`

That's an indication of a hijacked swap drive.

Now we need that copy of fstab from your last installed distro. Compare the swap drive UUID in that to the one in Kubuntu

**Location:** `/etc/fstab`

If they are not the same, and they probably won't be, you will need to modify Kubuntu's fstab. Here's how:
- Open it with Kate
- Duplicate the swap drive line and comment that line out ( add a # mark to the front of the line )
- Change the UUID of the swap drive to the one from that saved copy of fstab from the other OS
- Save the file.
- In terminal run the command
  ```shell
   $: mount -a
   ```


**You are done.**


### Phase 8 Troubleshooting

If you find yourself stuck at a grub prompt after all this, the problem lies in a text file or a subvolume name. You can fix it by booting into Linux Live USB and going over your work.

Once you have done this a few times and understand where everything goes, you can actually do nearly all of it in Krusader much more quickly than using the method I outlined above. However be aware that Krusader
can seriously break your system should you make a mistake or just hit the wrong key. **Use Krusader with extreme caution.**

**Problem:**
Grub error that says something to the effect of:
`Cannot open access to console, the root account is locked`

Possible Solution:
Check your all of your "subvol=" fields, including the one in 40_custom to make sure it has the forward slash " / " .

**Problem:**
Grub kernel panic

Possible Solution:
Your symlinks may not be set up properly. Double check your work in 5J and 5K.




**problem**
ruh-roh! You scewed up somewhere and can't find your error and you just want to start over...

Possible Solution:
You can just delete the subvolumes of the OS in question (not your main OS though).

You can try using the btrfs command to delete them. But if like me you get `ERROR: Could not statfs: No such file or directory.`

Then boot up your Linux Live, find the subvolumes in terminal and remove them with `rm`
```shell
$ sudo rm -rfv @subvolume_name
```

### Notes on using Krusader

Krusader is a really powerful tool which can really break your system if you hit a wrong key. So be extra careful when using it.

Almost everything in this tutorial that involves editing, copying, or renaming can be done faster using Krusader in root mode.

Krusader makes file copying really easy. One panel represents 'from' and the other 'to'. To back a file up to its own directory
open that directory in BOTH panels. Then just use the copy-button at the bottom. The rest is pretty intuitive.

Krusader-Edit's Find and Replace isn't quite as luxurious as Kate's. But it will get the job done just as quickly, maybe even just a little bit faster.


### Alternative Method to Using Live-USB to Configure Secondary Distros

You won't be able to rename the subvolumes for the distro you are currently booted into. ( Well you CAN, but you will regret it. )

This is faster than using a Live-USB.  Everything done the other way in Live-USB can be done this way via your main distro.

The difference here is that you will be mounting your BTRFS root subvolume and using Krusader from your actual installed Kubuntu to
edit the files and rename the subvolumes. I also have some .sh scripts to make some of this easier. ( Use at your own risk!!! ). I
will not explain "basic" shell commands such as directory switching or renaming.


To mount BTRFS root:
Get your device name:

`findmnt -vno SOURCE /home/`

Make a directory `/mnt/btrfsroot/`

Mount the btrfs root:

`mount -o subvolid=5 [device] [mount-point]`

Looks like:
`sudo mount -o subvolid=5 /dev/sda3 /mnt/btrfsroot/`

Navigate into that directory and now you can access all the files directly.

When you are done, un-mount
Note: the un-mount command only as one letter 'n' and it's toward the end.
`sudo umount /mnt/btrfsroot/`

Remove the mount point.
`rmdir /mnt/btrfsroot`