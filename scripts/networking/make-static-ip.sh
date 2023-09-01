#!/bin/bash
## set static IP Address

# Display usage and help
if [[ $1 ]]
  then
  echo -e "\n"
  echo -e "$0 accepts no arguments except to display this message.\n "
  echo -e "$0 requires root access. You will be asked for your password. "
  echo -e "This script can be found at: $(pwd)"
  echo -e "This script creates a static ip address for a given network."
  echo -e "You will need a static ip on your network to connect to your"
  echo -e "machine using an ssh alias. Ask your network admin to reserve"
  echo -e "you an IP address on the router.\n"
  echo -e "The script will display some information about your machine."
  echo -e "You will need to copy and paste information from/to your terminal."
  echo -e "You will be able to find the generated file at:"
  echo -e "/etc/NetworkManager/system-connections/[UUID]network-name.nmconnection"
  exit 0
fi


# ip of DNS server
declare DNS="1.1.1.1"
declare subnet="255.255.255.0"
declare mask="/24"

# UUID of router on computer
declare UUID

# SSID of router
declare SSID

# host wifi transceiver device name
declare device

# ip of computer on network
#declare oldIP

# desired IP for the computer
declare desiredIP

# the network password
#declare pass


# ip of router
declare gateway
# gateway address of router

echo -e "\nYou should be connected to the network you are setting the IP for."
echo -e "At the end you will need to stop and start your connection by your"
echo -e "usual method for the change take effect."
echo -e "This script uses a fixed DNS of 1.1.1.1"
echo -e "It also uses a fixed CIDR ( subnet mask ) of /24."
echo -e "You can change either at the top of the script.\n"

echo -e "We need to get some information."
echo -e "You will need to copy and paste it from terminal output."
echo -e "Double clicking should correctly select all fields that don't"
echo -e "contain spaces.\n"


echo -e "What static IP do you want for your computer?"
read desiredIP
# strip leading and following  white space
desiredIP=$(echo "${desiredIP}" | xargs echo -n)
echo -e "You entered: ${desiredIP}\n"

echo -e "Copy and paste the router gateway address."
ip r | grep default
read gateway
# strip leading and following  white space
gateway=$(echo "${gateway}" | xargs echo -n)

#echo "We will need the name, the UUID, and device."
echo "We will need the name, and UUID."


echo -e "It's probably in the top line, which may be a different color than the rest.\n"
# find UUID with `$ nmcli con show `
nmcli con show
echo -e "\nCopy and paste the SSID (name) of the router:\n"
echo -e "if the name contains a special character, put enclosing quotes around the name.\n"
read SSID
# strip leading and following  white space
SSID=$(echo "${SSID}" | xargs echo -n)
echo -e "You entered: ${SSID}\n"

echo 'Copy and paste the UUID:'
read UUID
# strip leading and following white space
UUID=$(echo "${UUID}" | xargs echo -n)
echo -e "You entered: ${UUID}\n"

#echo 'Copy and paste the device:'

#read device
#echo -e "You entered: ${device}\n"


#echo -e "The following output will tell us the subnet mask.\n"
#ifconfig $device | grep netmask


#echo -e "\nNow look at subnet."
#echo -e "If is NOT ${subnet} then you need to change the variable in the file to match what you see above.\n"

#echo "gateway is: ${gateway}"
#echo "DNS is ${DNS}"

echo -e "Setting static IP and CIDR."
sudo nmcli con modify ${UUID} ipv4.addresses  ${desiredIP}${mask}
echo -e "Setting gateway address."
sudo nmcli con modify ${UUID} ipv4.gateway ${gateway}
echo -e "Setting DNS."
sudo nmcli con modify ${UUID} ipv4.dns ${DNS}
echo -e "Setting method to 'manual'.\n"
sudo nmcli con modify ${UUID} ipv4.method manual
# despite what various docs say, this does nothing
#sudo nmcli con modify ${UUID} wifi-sec.psk ${pass}
# this works, but poorly. Better to reactivate the connection with the GUI.
#sudo nmcli -a connection up ${UUID}
sudo cat /etc/NetworkManager/system-connections/"${SSID}.nmconnection"