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
- root privileges
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


## Common terminal commands we will use:

"Update grub" means open a terminal and type in the following commands:
```shell
sudo grub-mkconfig
sudo update-grub
```
Renaming files use the move command with sudo.
```shell
sudo mv oldname newname
```

Making a backup copy - use the copy command and add a tilde to the copy name:
```shell
sudo cp filename filename~
```

### Phase 1 - Drive Partitioning -- A very sparse overview

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


### Phase 2 - Install primary OS (assumes: Kubuntu LTS xx.04 )

You will need your Kubuntu live USB. Choose "try Kubuntu"
Configure your wifi network and bluetooth pointer in the test distro. Your settings will be transferred to the installer and your final installation. It's also easier than doing it in the installer interface.

At entrance to the partitioning section, choose "Manual" or "Something else" or the equivelent.

DO NOT
- let the installer automatically configure your drive ( NO )

Install to sda3
Make sure to choose "/" as mount point. The selection box is placed below and easy to miss.


### Phase 3 Configure the primary OS ( assumes Kubuntu )

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
 - Edit => Replace ( NO )
 - CTRL+ F  ( NO )

It lacks the features we need

DO : 
- Go to the BOTTOM of the window and choose "Search and Replace" ( YES )

In the "Find" bar enter @ and click "Search"
You'll see a bunch of lines that look like:

linux	/@/boot/vmlinuz-5.19.0-46-generic root=UUID=73ffa900-dca2-47f2-9e0b-f8c1942ef918 ro rootflags=subvol=@  quiet splash $vt_handoff

Note that there is an "@" at the beginning and "subvol=@" at the end. These will be handled a little differently.

We need to change all the @ to @ku. So enter @ku in the "Replace" field and click "Replace"
The lines should look like this:

linux	/@ke/boot/vmlinuz-5.19.0-46-generic root=UUID=73ffa900-dca2-47f2-9e0b-f8c1942ef918 ro rootflags=subvol=@ku  quiet splash $vt_handoff

We are not done. The world will end in dragonfire if we don't add a forward slash to all the subvol fields. So:

- In the "Find" bar enter "subvol="

- In the "Replace" bar enter "subvol=/" and click Replace

It should look like:

linux	/@ke/boot/vmlinuz-5.19.0-46-generic root=UUID=73ffa900-dca2-47f2-9e0b-f8c1942ef918 ro rootflags=subvol=/@ku  quiet splash $vt_handoff

Manually look over all the changed lines and make sure everything looks as it should.

Save and exit.



Part D - Modify grub.cfg ( told you )
location: /boot/efi/EFI/ubuntu/grub.cfg
This step is to modify the grub $prefix variable. If you don't do this, you will get stuck at the grub prompt. That would be bad. Also, this step doesn't work the same for every distro (Kali for example). 

We will use Krusader file explorer. It is not installed by default. So open the package manager Muon and install Krusader.

Open Krusader and click through it's first time start up routine. Accept everything then go to Tools >> Start Root Mode Krusader and repeat the start up routine.

Now navigate to /boot/efi/EFI/ubuntu/ and select grub.cfg

At the bottom of the window click "f4 Edit"

The second line should read:
"set prefix=($root)'/@/boot/grub'"

Change @ => @ku and save the file. 

Close Krusader.

Update grub.

### Phase 4 Install the Second OS
I will only give some DOs and DO NOTs here as each distro is different.

DO: Install to the same btrfs partition as before. ( YES )

DO NOT:

- Change your drive partitions ( NO )
- Choose automatic anything ( NO )




### Phase 5 Rename subvolumes and configure secondary OS

We are going to copy some data from your seconary OS to your main OS. You will need a way to get it over there. I used a USB stick as file-transfer media.

Firstly, decide what you are going to call your new subvolumes. I installed Kali on my system so I chose @kali. You might use @mint or @manjaro, etc. 

These steps are very similar to what you did previously so I will only notate the parts that are different. For the most part you will do everything the same way.
This can be done from the Kubuntu Live USB (easy) or from within the installed version of Kubuntu (intermediate) which I do not cover here.

DO NOT:
- reconfigure grub $prefix. ( NO )
- install Krusader in the 'try' version of Kubuntu. ( NO )

You will not need Krusader for this. And Kubuntu will "own" grub and will boot the computer. ( look up boot up vs start up )

Start by saving a copy of /etc/fstab to your file-transfer media. We may need a piece of information in it at the very end of this long process.

Now we are going to copy some code out of the secondary OS grub.cfg.
location: /boot/grub/grub.cfg
You will need to copy the code to your Kubuntu install. I used a USB stick. There are other ways.

Find the section " ### BEGIN /etc/grub.d/10_linux ### "

copy the first menu entry that looks something like this:

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

Just a reminder: make sure you have a copy of your secondary distro fstab file before you log out of it.

Reboot into Kubuntu

### Phase 6: Boot into and configure primary OS (again)

We need to make the following changes to two of the last four lines of the extracted code. Make sure you have a backup copy before you start.

Firstly, note the "echo" commands. They print messages to the grub bootup screen. Feel free to make them say whatever you find useful or amusing. You can also safely delete them.
The two lines we need to change are the "linux" and "initrd" command lines.

Change the three "@" subvolume names down at the bottom to whatever you intend to name your new distro @ subvolume.

Now we are going to change the file names being used. If we don't do this, our shiny new dual boot system will break the first time the Linux kernel is updated and we may not remember how to fix it. So let's prevent it.

In my sample text the file names are:

- vmlinuz-6.1.0-kali9-amd64

- initrd.img-6.1.0-kali9-amd64

To get this step right you may have do it a few times because not all distros handle this part the same way. So there may be some trial and error.

If you are in an Ubuntu variant you need to change the file names to:
- vmlinuz
- initrd.img

Some distros won't accept that. But we may be able to take advantage of [globbing](https://en.wikipedia.org/wiki/Glob_(programming)) ( fancy text manipulation magic ). For Kali what worked was to insert a wildcard character at then end, which looks like
- vmlinuz*
- initrd.img*

You can optionally remove "quiet splash" in the `linux` command which will turn of the splash screen and show you the helpful system start up messages. Being able to see those messages may make your life easier and is recommended.

Double check that everything is correct ( see below for example ) and paste it into the file '40_custom' in your main distro.

location: /etc/grub.d/40_custom


Example of modified grub code: ( only the last four lines are different )
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

Update grub.

Reboot and make sure your secondary OS shows up in the grub menu. 

If it's there, select it and boot it.

If just sends you back to the grub menu OR it's not there at all:
- check your 40_custom code syntax, make corrections, and update grub. Check all the syntax, { braces }, etc.

If it starts to boot then just hangs with a message of "kernel panic" then it may be how you named your kernel file in 40_custom.

Try something else. I don't know what to try. But try something! If it works, please drop me a note on what you did so I can add it to this tutorial.

Remember, after changing your grub files, update grub.


### Phase 7 Final Cleanup

The last thing to do is to see if the last distro you installed hijacked your swap drive. It's okay if it did. It's easy to fix.

You may have seen a message with a long countdown while starting your main OS to the effect of "startup process /dev/disk/by-uuid/someUUID" 

That's an indication of a hijacked swap drive.

Now we need that copy of fstab from your last installed distro. Compare the swap drive UUID in that to the one in Kubuntu (/etc/fstab). 
If they are not the same, and they probably won't be, you will need to modify Kubuntu's fstab. Here's how: 
 - Open it with Kate
 - Duplicate the swap drive line and comment that line out ( add a # mark to the front of the line )
 - Change the UUID of the swap drive to the one from that saved copy of fstab from the other OS
 - Save the file.
 - In terminal run the command 
  ```shell
   $: source /etc/fstab
   ```


You are done. 






