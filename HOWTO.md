# How To the
The entire guide can eb done headless but it's recommended to not completely run it headless. The testing of this was done with the PiZero hooked up to a monitor for debugging
The install shortcut can be done later

## Needed Items
* Host Machine with Internet Access and Administrative Rights
* [Bonjour](https://support.apple.com/kb/DL999) service or equivelant on the machine (Windows 10 has this already)
* microSD Card
* PiZero
* Disk imaging Tool ([Win32DiskImager](https://sourceforge.net/projects/win32diskimager/) used here)
* Text editor
* MicroHDMI to HDMI cable (+ any required adapters for your display)
* SSH client (e.g. [Putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html?) on Windows)

## Prep
* Using your favourite OS and imaging tool write the latest version of Raspian Jessie Lite to the microSD card. (The version used in the testing was dated 2017-01-11)
* Ensure the PiZero can boot from it (no interaction needed just needs to boot)

## Enable OTG networking
* Take out the microSD card and plug it into your favourite OS again to edit files in the boot partition
* Using a text editor add ```dtoverlay=dwc2``` to the bottom of ```config.txt```
* Edit ```cmdline.txt``` in the same way. Look for ```rootwait``` in the line and add ```modules-load=dwc2,g_ether``` after it so it looks like ```rootwait modules-load=dwc2,g_ether```
* The PiZero shouldbe able to be booted via the OTG port with a decent microUSB cable
* Plugin the PiZero to the host machine for the rest of the setup
* Create an empty file called ```ssh``` next to config.txt and commandline.txt ensuring no extention. You may need to view file extentions here

## Host machine
* The Host machine needs to be able to share it's internet connection with the PiZero (Administrative Rights needed)
* On Windows 10, Goto network connections and adapter settings.
* On the connection used for the internet right click and select properties.
* The tab "sharing" should be available with the dropdown menu of available network adapters
* Select the one for the PiZero

## PiZero Config Setup
* SSH to the using the hostname ```raspberrypi.local``` and default credentials of username ```pi``` and password ```raspberry```
* Changing the password, on successful login change the default password to something secure using ```passwd```
* Setup the PiZero using raspi-config
** Boot Options -> Desktop/cli -> Select Option B1 "Text console, requiring user to login"
** Enable SSH -> Yes
** Finish -> Reboot -> Yes
* Log back in via SSH

## Checkout the repo and install
* On the command line run ```git clone <repo url>```
* Change directory into it with ```cd <foldername>```
* Run install.sh as root ```sudo ./install.sh```
* Voila!

## Accessing the Data
* To Access the data captured it's much easier use a macOS machine of another linux machine to read the Raspian filesystem
## OR
## Future Work
* Add Tactile switch to GPIO
* on pressing GPIO exposes FAT32 mass storage device instead of network adapter to host
* Access PiZero like a memory stick to copy payloads off

## The TLDR Way
* Attach Screen and Keyboard to PiZero
* Setup up OTG image as above
* Login to Pi with keyboard, drop to root (```sudo su```) and run ```curl | <raw github url to build.sh>```
