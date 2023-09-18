## Sharing Applications 
###(between Multiple Distros on a Single BTRFS Partition)

Assumptions:
- There is only one user on the system. Additional users will require additional configuration, which is not covered here.

We will be working with the @dotfiles subvolume

**Subvolume Mount Table:**

| subvolume | mount point | owner |
|-----|------|-------|
| @programs | /mnt/programs | root |

Before beginning, make sure your fstab has mounted the appropriate subvolume.

**Benefit:** \
You will have some applications that you frequently use installed in one central location and available to multiple distros,
saving disc space.

**Snaps** \
Nope.

**Java Runtime Applications** \
Some applicationss that I really like such as WebStorm and DIY Layout Creator rely on Java runtimes and are 
entirely encapsulated in a single folder and make system calls to the runtime of the executing distro. These
are the easiest to share between distros. All that is necessary is that they reside at an accessible location.

All you have to do is install them (or copy their whole folder) to the @programs subvolume.

Call them as you would any other program.
 
**Flatpak** \
Flatpaks are more complicated. Flatpak itself must be configured to work this way (they have docs for this). Then you 
have to install every flatpak application in each distro. The extra disc space it uses up over the first installation
is a few hundred kb. But Flatpaks themselves are pretty disc-space intensive. It may take up more space to install one 
flatpak than to install the same application the old-fashioned way in multiple distros.

My testing of this has been minimal. The only flatpak I use routinely this way is Firefox, which seems to work well. Bookmarks and settings
are NOT shared by default. I don't know if there is a way to share them.

Another thing to consider is that many flatpaks were not created and are not maintained by the original app developer, but
by someone else. Chromium and WebStorm are two such. Maybe it's fine. I don't know. I prefer to err on the side of vigilance. Consider 
yourself warned. Here's how to do it:

[Docs for how to change default installation location](https://docs.flatpak.org/en/latest/tips-and-tricks.html#adding-a-custom-installation)

When adding repos or installing you MUST specify `--installation=extra` EVERY TIME

Put extra.conf in each distro. 
I use an ssd and install to my @programs subvolume.

Here's my version of extra.conf:
```shell
[Installation "extra"]
Path=/mnt/programs/
DisplayName=Extra Installation
StorageType=harddisk
```




