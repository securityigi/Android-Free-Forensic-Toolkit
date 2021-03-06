#!/bin/bash
echo ""
echo "Imaging command sent"
echo "Giving device 10 seconds to process command"
sleep 10 # ADB needs time to connect to the device and send the command before we get things set up on the PC
currentDir=$(pwd)
adb forward tcp:5555 tcp:5555 # sets up connection from which we recieve the data stream
cd $1
nc 127.0.0.1 5555 | pv -i 0.5 > image.dd # obtains the dd image from the device via aforementioned connection
mkdir ../mount
gdisk -l image.dd > partitioninfo # gets partition info from the image. We'll need this for mounting the files later
cat ./partitioninfo | awk 'f;/Number/{f=1}' > tmpdata # strips the header from the data, makes parsing via script much easier.
cat ./tmpdata | awk '{print $2, $7}' > ../mount/mountinfo # alters the patition info file to include info only useful to the mounting script
cd $currentDir
