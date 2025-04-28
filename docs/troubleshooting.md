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







