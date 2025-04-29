
### To do a full upgrade
Note: if the upgrade fails for some inexplicable reason, there may be a dependency issue or a broken kernel or what not.
Check out the [troubleshooting page](docs/troubleshooting.md)

Don't use the automatic tool. It may overwrite your configurations. (I actually don't know if it will, I didn't trust it.)
Use the command line like a Proper Nerd!

`sudo do-release-upgrade | tee ~/Documents/upgrade.log`

The first half starts the attended upgrade process (meaning you must attend to it and occasionally make a decision)
The second half outputs the upgrade logs to your documents subvolume, so you can read them later (useful for troubleshooting).

Using the CLI means that when it goes to write a file tha you have modified, it will ask you if you want to keep the old one. Yes, yes
you probably do.


**Do NOT**
Do not try to install another version of Kubuntu alongside another version of Kubunut. It probably won't hurt your system at
all. But when I tried it, grub was not updated and I couldn't get the new install to boot. I considered modifying my 
40_custom file to put the new version on the grub menu and try to trick it into booting so I could update grub from within. 
But I got the system to upgrade itself before that.



