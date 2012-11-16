#!/bin/sh
# Script to get some basic info about a host then
# append it to a file in a form that looks nice on mediaWiki
# Abandon-All-Hope

if test -z "`uname -a|grep Linux`" ; then echo Not Penguin, see ya'!' ; exit; fi
FILE=/tmp/hostsinfo.txt;
ls /tmp > /dev/null;
PN=`/usr/sbin/dmidecode | egrep 'Product Name:' | grep -v Not | head -1 `;
SN=`/usr/sbin/dmidecode | egrep 'Serial Number:' | grep -v Not | head -1 `;
NP=`grep processor /proc/cpuinfo | wc -l`;
FM=`free -g | grep Mem:|awk '{print $2}'`;
RH=`cat /etc/redhat-release`;hostname  >> $FILE;
echo \* $PN >> $FILE;
echo \* CPU\(s\):  $NP >> $FILE;
echo \* Memory: ${FM}G >> $FILE;
echo \* OS: $RH  >> $FILE;
echo \* $SN >> $FILE;
echo ""  >> $FILE;

cat << EOF >> $FILE
=== Network interfaces ===
{| class="wikitable"
|-
EOF
for i in `grep ONBOOT= /etc/sysconfig/network-scripts/ifcfg-*|grep yes|awk -F: '{print $1}'|grep -v ifcfg-lo` ; do
ipaddr=`grep -i ipaddr $i|awk -F\= '{print $2}'`
hwaddr=`grep -i hwaddr $i|awk -F\= '{print $2}'`
device=`grep -i device $i|awk -F\= '{print $2}'`
hostname=`getent hosts $ipaddr|awk '{print $2}'`
echo \| $hostname \|\| $ipaddr \|\| $device \|\| $hwaddr  >> $FILE
echo \|- >> $FILE
done
echo \|\} >> $FILE
