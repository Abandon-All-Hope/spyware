#!/bin/sh
F=/mnt/hostsinfo.txt;
ls /pub/tmp > /dev/null;
PN=`dmidecode | egrep 'Product Name:' | grep -v Not | head -1 `;
SN=`dmidecode | egrep 'Serial Number:' | grep -v Not | head -1 `;
NP=`grep processor /proc/cpuinfo | wc -l`;
FM=`free -g | grep Mem:|awk '{print $2}'`;
RH=`cat /etc/redhat-release`;hostname  >> $F;
echo \* Product Name: $PN >> $F;
echo \* CPU\(s\):  $NP >> $F;
echo \* Memory: ${FM}G >> $F;
echo \* OS: $RH  >> $F;
echo \* Serial Number: $SN >> $F;
echo ""  >> $F;
cat << EOF >> $F
=== Network interfaces ===
{| class="wikitable"
|-
EOF
for i in `grep ONBOOT= /etc/sysconfig/network-scripts/ifcfg-*|grep yes|awk -F: '{print $1}'|grep -v ifcfg-lo` ; do
ipaddr=`grep -i ipaddr $i|awk -F\= '{print $2}'`
hwaddr=`grep -i hwaddr $i|awk -F\= '{print $2}'`
device=`grep -i device $i|awk -F\= '{print $2}'`
hostname=`getent hosts $ipaddr|awk '{print $2}'`
echo \| $hostname \|\| $ipaddr \|\| $device \|\| $hwaddr  >> $F
echo \|- >> $F
done
echo \|\} >> $F
