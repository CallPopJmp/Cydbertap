#!/bin/bash
currentDate="$(/bin/date +'%Y%m%d')"

##Debug Date
#currentDate="20170206"

##Environment variables:
pcapPath="/home/pi/cydbertap/pcaps/"
objPath="/home/pi/cydbertap/objects/"
capTipperPath="FULL_PATH_TO_CAPTIPPER_HERE.py"
#echo "debug: currentD: " $currentDate
#echo "debug: pcapPath: " $pcapPath
#echo "debug: ObjsPath: " $objPath

##Merge job PCAP files:
dateDir=$(find $pcapPath -type d -iname $currentDate)
echo "debug: DatePath: " $dateDir
mkdir $objPath/$currentDate
/usr/bin/mergecap $dateDir/* -w $objPath/$currentDate/$currentDate.merge.pcapng

##Process job PCAP file to extract objects:
fileToProcess=$(find $objPath/$currentDate/$currentDate.merge.pcapng)
echo "debug: CapTipper processing file: " $fileToProcess
sudo /usr/bin/python $capTipperPath $fileToProcess -d $objPath/$currentDate/ 2>$objPath/$currentDate/capTipper_errors.log 1>$objPath/$currentDate/capTipper_stdout.log

##Extract IOCs from output:
/usr/sbin/tcpdump -Annr $fileToProcess | egrep "\b((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}\b" -o | cut -d\. -f1,2,3,4 | sort | uniq -c | sort -nr > $objPath/$currentDate/$currentDate.IP.counts.txt
/usr/sbin/tcpdump -Annr $fileToProcess | grep "User-Agent" | sort | uniq -c | sort -nr > $objPath/$currentDate/$currentDate.UA.histogram.txt
/usr/sbin/tcpdump -Annr $fileToProcess | egrep "\:\/\/([^\/\"]{2,100})" -o | cut -d\/ -f3 | sort | uniq -c | sort -nr > $objPath/$currentDate/$currentDate.Domains.counts.txt

#Finished message
echo "Job Finished. All output was written to: " $dateDir
