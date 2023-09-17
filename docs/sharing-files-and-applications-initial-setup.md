## Initial Setup for Sharing Files and Application
###(between Multiple Distros on a Single BTRFS Partition)

Assumptions:
- There is only one user on the system. Additional users will require additional configuration, which is not covered here.

**Subvolume Mount Table:**

| subvolume | mount point | owner |
|-----|------|-------|
| @data | /mnt/data | root |
| @dotfiles |  /mnt/dotfiles | $USER |
| @programs | /mnt/programs | root |
| @tardis |  /mnt/tardis | $USER |



Add following subvolumes to main system partition ( sda3 for me )

@data
@dotfiles
@programs
@tardis


### Mount root BTRFS 
You will need to mount the root BTRFS subvolume to add the new subvolumes. Once mounted cd
into that directory.

`sudo mount -o subvolid=5 $device $mountPoint`

On my system that looks like

`sudo mount -o subvolid=5 /dev/sda3 /mnt/bfsroot`



### Mounting the subvolumes
- **Create Mount Points** \
In each distro \
``` shell
sudo mkdir -p /mnt/data
sudo mkdir -p /mnt/dotfiles
sudo mkdir -p /mnt/programs
sudo mkdir -p /mnt/tardis
sudo chown [user]:[group] /mnt/data 
sudo chown [user]:[group] /mnt/dotfiles
sudo chown [user]:[group] /mnt/programs 
sudo chown [user]:[group] /mnt/tardis 
```




### Modify fstab
In each distro \
**Location:** `/etc/fstab`

- Copy the line for /home and change "home" to whatever you named your directory\
Do this for each of the new subvolumes.

- reload fstab
  `mount -a`

- If it tells you to run `systemctl daemon-relaod` do so.








