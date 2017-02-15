#!/bin/bash
cd /home/pi/cydbertap
count=1
# loops 6 times to give 30 minutes of pcap
while [ $count -le 6 ] 
do
if [ $count -le 6 ]
  then
   #gives date in format YYYYMMDD-HHMMSS
   FILETIME=$(date +"%Y%m%d-%H%M%S")
   #Sets filename
   FILENAME="PC-"$FILETIME".pcap"
   #Runs TCPDump as root captures 5 minutes
   tcpdump -Z root -w $FILENAME -G 300 -W 1
  fi
  (( count++ ))
done
