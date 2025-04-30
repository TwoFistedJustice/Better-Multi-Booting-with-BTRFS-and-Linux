# Troubleshooting
## Or how I fixed stuff that broke



### Grub

The timer kept defaulting back to 30 seconds.
Set Record Fail Timeout

**Location:** ```/etc/default/grub```
```shell
GRUB_TIMEOUT_STYLE=countdown
GRUB_TIMEOUT=5
# If your timer keeps defaulting to 30 seconds,
# Grub Record Fail Timeout is the env var to set.
GRUB_RECORDFAIL_TIMEOUT=5
```


### Kernel Panic
Oh no! The computer froze during start up and says "Kernel panic"! What should you do?

Just because the kernel is panicking doesn't mean you should!

It might say something like "can't find sda3" or "what the hell is a subvolume???"

It's just being melodramatic.This is just what happens when kernels panic.

You should choose "Ubuntu Advanced Options" at the grub menu the boot from the next non-recovery kernel
down the list. Keep doing that till you either get to your desktop or run out of kernels.

Once you are in your system all good and proper open a terminal and run some utilities to rebuild your
broken kernel.

`sudo dpgk --configure -a`

If that doesn't work, well then I can't help you. Go ahead and panic if it helps you.

### System updates fail or full upgrade fails.

Something's broke I reckon.

Start with:
`sudo dpgk --configure -a`

In my case, attempting to install updates failed because package-kit had an unmet dependency.

I fixed that with (no additional parameters needed): 
`sudo apt --fix-broken install`

Then ran `sudo apt-get upgrade` which upgrades all the various little packages.  

ran `sudo apt-get autoremove` - it removed all the left over junk and ALL old linux kernels, so no way to recover... [how to prevent that?]
All those cli tools installed most of the needed updates, only the kernel update remained (went from 650MB to 6.5kb)
Installing 6.8.5-58 generic


### To do a full upgrade
Don't use the automatic tool. It may overwrite your configurations. (I actually don't know if it will, I didn't trust it.)
Use the command line:

`sudo do-release-upgrade | tee ~/Documents/upgrade.log`

The first half starts the attended upgrade process (meaning you must attend to it and occasionally make a decision)
The second half outputs the upgrade logs to your desktop, so you can read them later (useful for troubleshooting).

Using the CLI means that when it goes to write a file tha you have modified, it will ask you if you want to keep the old one. Yes, yes
you probably do.






