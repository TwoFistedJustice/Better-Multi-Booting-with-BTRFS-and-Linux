# Sharing Files 
###(between Multiple Distros on a Single BTRFS Partition)


Assumptions:
- There is only one user on the system. Additional users will require additional configuration, which is not covered here.

We will be working with the @tardis subvolume

"tardis" is for long-term personal files going back decades. It is the "time travel" (memories) folder.  

**Subvolume Mount Table:**

| subvolume | mount point | owner |
|-----|------|-------|
| @tardis |  /mnt/tardis | $USER |

Before beginning, make sure your fstab has mounted the appropriate subvolume.

**Benefit:** \
You will be able to easily access your personal files from all your distros.

Copy all of your forever-files here.

That's pretty much it.