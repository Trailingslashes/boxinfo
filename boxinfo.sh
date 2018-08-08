#!/bin/sh



echo ""
echo "SYSTEM INFORMATION"
echo "=================="
echo ""

# hostname
printf "Hostname: "
hostname -f


# logged in
printf "Currently Logged In: "
LOGINS=`who | wc -l`
if [ "$LOGINS" = 0 ]
then
 echo " Nobody"
else
 who | awk '{print $1}' | head -1
fi

# last login

#printf "Last login: \t"
#last | head -1

# what's my OS?
echo " "
echo "OS Build:"
cat /etc/issue
echo " "

# CPU info
echo "CPU Information:"
COUNT=`grep "model name" /proc/cpuinfo | sed 's/^[a-z \t]*://g' | wc -l`
printf "Proc: $COUNT (total) x "
grep "model name" /proc/cpuinfo | sed 's/^[a-z \t]*://g' | tail -1
printf "MHz: "
grep "cpu MHz" /proc/cpuinfo | tail -1 | awk '{print $4}'
PHY_PROC=`grep 'physical id' /proc/cpuinfo | sort -u | wc -l`
printf "Physical Procs: $PHY_PROC"

#BIOSINFO=`dmidecode | head -15 | grep Version | sed -e 's/\t\t\s\w.*\sv//'`
echo ""
echo ""

# memory info
MEMTOTAL=`grep MemTotal /proc/meminfo | awk '{print $2}'`
MEMTOTAL=`expr $MEMTOTAL / 1024`
MEMFREE=`free | head -3 | tail -1 | awk '{print $4}'`
MEMFREE=`expr $MEMFREE / 1024`
SWAPTOTAL=`grep SwapTotal /proc/meminfo | awk '{print $2}'`
SWAPTOTAL=`expr $SWAPTOTAL / 1024`
SWAPFREE=`grep SwapFree /proc/meminfo | awk '{print $2}'`
SWAPFREE=`expr $SWAPFREE / 1024`
echo "Memory Information:"
echo "RAM : $MEMTOTAL MB total, $MEMFREE MB free"
echo "SWAP: $SWAPTOTAL MB total, $SWAPFREE MB free"

# video card info
echo ""
if [ -x /usr/bin/nvidia-smi ]
then
    echo "Video Card:"
    /usr/bin/nvidia-smi | awk 'NR >= 8 && NR <= 8' | awk -F '  +' '{print $3}'
    echo ""
    echo "Nvidia Driver:"
    /usr/bin/nvidia-smi | awk 'NR >= 3 && NR <= 3' | awk -F ' +' '{print $6}'
elif [ -f /proc/driver/nvidia/cards/0 ]
then
    echo "Video Card:"
    cat /proc/driver/nvidia/cards/0 | cut -c11-999 | head -1  | sed 's/Model/Video/g'
    echo ""
    echo "Nvidia Driver:"
    cat /proc/driver/nvidia/version | grep "NVIDIA" | awk '{print $8}'
elif [ -f /proc/driver/nvidia/gpus/0/information ]
then
    echo "Video Card:"
    cat /proc/driver/nvidia/gpus/0/information |cut -c11-999 | head -1  | sed 's/Model/Video/g'
    echo ""
    echo "Nvidia Driver:"
    cat /proc/driver/nvidia/version | grep "NVIDIA" | awk '{print $8}'
else
 printf "Video:\tNo NVIDIA card\n"
fi


# sound card
echo ""
echo "Sound Card:"
if [ -x /sbin/lspci ]
then
/sbin/lspci | grep -i audio | cut -c14-999 | sed 's/^[a-z 0-9]*: //g' | head -1
else
/usr/bin/lspci | grep -i audio | cut -c14-999 | sed 's/^[a-z 0-9]*: //g' | head -1
fi


# network card info
echo ""
echo "NIC Card:"
if [ -x /sbin/lspci ]
then
/sbin/lspci | grep -i ether | cut -c14-999 | sed 's/^[a-z 0-9]*: //g' | head -1
else
/usr/bin/lspci | grep -i ether | cut -c14-999 | sed 's/^[a-z 0-9]*: //g' | head -1
fi

#echo " "
#echo "Eth0 firmware version "
#/usr/sbin/ethtool -i eth0


echo " "
# local drive info
echo "Local Drives:"
df -h | grep dev | sort | egrep 'sd|hd|md'

echo " "
# load
echo "UPTime: "
uptime

OSREV=0
if [ -f /etc/lsb-release ]
then
 OSREV=`cat /etc/lsb-release | grep DISTRIB_DESCRIPTION | sed 's/DISTRIB_DESCRIPTION=/ /g'`
fi




