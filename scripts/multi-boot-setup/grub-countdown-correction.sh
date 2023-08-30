#!/bin/bash
# grub-countdown-correction.sh
# if after setting your grub env variables in /etc/default/grub you still get an
# undesirable 30 second countdown, run this script to set the number of seconds
# you want for your countdown.
# if you want to set 10 seconds:
# usage: grub-countdown-correction.sh 10


if (( $# != 1 ))
  then
    echo "usage: $0 seconds-to-count-down "
    exit 1;
fi


if [[ -f /etc/default/grub ]]
  then
      echo -e "# If your timer keeps defaulting to 30 seconds," >> /etc/default/grub
      echo -e "# Grub Record Fail Timeout is the env var to set." >> /etc/default/grub
      echo -e "GRUB_RECORDFAIL_TIMEOUT=${1}" >> /etc/default/grub
      exit 0
   else
     echo -e "GRUB_RECORDFAIL_TIMEOUT not set. The file /etc/default/grub seems to be missing."
     exit 1
fi
