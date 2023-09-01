#!/bin/bash
# make-ssh-alias.sh
# this script creates an entry at ~/.ssh/config to help you quickly connect to another host
# Just run the script and follow the prompts.
# It adds hostname, IP Address, port, user name, and whether you want random art confirmation on connect.


# Display usage and help
if [[ $1 ]]
  then
  echo -e "\n"
  echo -e "$0 accepts no arguments except to display this message.\n "
  echo -e "This script creates an entry at ~/.ssh/config to help you"
  echo -e "quickly connect to another host.  Follow the prompts to"
  echo -e "provide host name, IP address, port, and user name of the"
  echo -e "machine to which you want to connect.\n"
  echo -e "Before running this script you would type something like:\n"
  echo -e "ssh joe@192.168.1.1 -p 2022\n"
  echo -e "After setting up an alias you could do something like:\n"
  echo -e "ssh joe"
  exit 0
fi

declare Host
declare IpAddress
declare User
declare Port
declare VisualHostKey
declare useRandomArt
declare WriteString
declare Confirm
declare spacer="\x20\x20\x20\x20"
declare FilePath=~/.ssh/config

# Check if config file exists, exit if not.
if [[ ! -f $FilePath ]]
  then
    echo -e "No ssh config file exists at ${FilePath}\n"
    echo -e "Please make sure ssh is enabled and that a config file exists.\n"
    echo -e "Please make sure ssh is enabled and that a config file exists.\n"
    echo -e "The config file need not contain data but must be owned by the intended user.\n"
    exit 1
fi

# get host name
echo -e "What is the host name of the target computer?"
read Host
Host=$(echo "${Host}" | xargs echo -n)


#get IP Address
echo -e "What is the IP Address?"
read IpAddress
# strip excess white space
IpAddress=$(echo "${IpAddress}" | xargs echo -n)


#get User name
echo -e "What is the user name?"
read User
User=$(echo "${User}" | xargs echo -n)

# get port number
echo -e "What port number does the target computer use? "
read Port
Port=$(echo "${Port}" | xargs echo -n)

# ask about random art
echo -e "Would you like to use a RandomArt visual host key? (yes/no)"
read useRandomArt
# strip excess white space
useRandomArt=$(echo "${useRandomArt}" | xargs echo -n)

# inform user of their choice random art variable based on user input
if [[ $useRandomArt == "yes" || $useRandomArt ==  "y" || $useRandomArt == "Y" ]]
  then
    VisualHostKey="yes"
    echo -e "You have opted to use a Random Art visual host key.\n"
    else
      VisualHostKey="no"
      echo -e "You have opted to NOT use a Random Art visual host key.\n"
fi

# create formatted write string
WriteString="Host ${Host}\n${spacer}HostName ${IpAddress}\n${spacer}User ${User}\n${spacer}Port ${Port}\n${spacer}VisualHostKey ${VisualHostKey}\n"

# check with user that info is correct, write or exit
echo -e "The following data will be written to ~/.ssh/config:\n"
echo -e $WriteString

# confirm data with user prior to write, cancel if user gives any answer besides yes
echo -e "Is this correct? (yes/no)"
read Confirm
# strip excess white space
Confirm=$(echo "${Confirm}" | xargs echo -n)

if [[ $Confirm == "yes" || $Confirm ==  "y" || $Confirm == "Y" ]]
  then
      echo -e "Writing to file.\n"
     echo -e $WriteString >> $FilePath
#       echo -e "${WriteString}" >> ~/Desktop/hello.txt

      exit 0
    else
      echo -e "Operation canceled.\n"
      exit 1
fi
