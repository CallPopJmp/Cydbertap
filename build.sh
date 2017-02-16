#!/bin/sh

REPO=https://github.com/CallPopJmp/Cydbertap
REPONAME="$(echo $REPO | awk -F/ '{print $NF}' | sed -e 's/\.git//g')"
CLONED=0
depends_drivebypi()
{
  # update repo
  sudo apt-get update
  # install python gpio bindings and git
  sudo -E apt-get install -y python-rpi.gpio git tcpdump dsniff
}
check_cloned()
{
  if [ -f "dhcpd.conf" ]; then
    CLONED=1
  fi
}
clone_repo()
{
  cd /tmp
  git clone $REPO
  cd /tmp/$REPONAME
}

copy_repofiles()
{
  cp dhcpd.conf /etc/dhcp/dhcpd.conf
  echo dwc2 >> /etc/modules
  echo g_ether >> /etc/modules
  cat << EOF > /etc/network/interfaces
auto usb0
allow-hotplug usb0
iface usb0 inet static
	address 1.0.0.1
	netmask 0.0.0.0
EOF
  cp otg.sh /usr/local/bin/
  chmod 644 /usr/local/bin/otg.sh
  chmod +x /usr/local/bin/otg.sh

  cp drivebypi /usr/local/bin/
  chmod 644 /usr/local/bin/drivebypi
  chmod +x /usr/local/bin/drivebypi
  cat << EOF >>
/usr/local/bin/drivebypi
EOF
  #Dirty Hack to stick exit 0 at the end
  sed -i 's/exit 0//g' /etc/rc.local
  cat "exit 0" >> /etc/rc.local
}

cleanup()
{
  rm -rf /tmp/$REPONAME
}

run_build()
{
  if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
  fi
  
  depends_drivebypi

}

# This prevents partial running with curl piped straight to bash
run_build
check_cloned
if [ $CLONED -ne 1]; then
  clone_repo
fi

if [ $CLONED -ne 1]; then
  cleanup
fi
