#!/bin/bash
interface_list=` cat /proc/net/dev | awk '{i++; if(i>2){print $1}}' | sed 's/^[\t]*//g' | sed 's/[:]*$//g'`

for i in $interface_list
do
	ip=`ifconfig $i | grep netmask | awk '{print $2}'`
	echo $i:$ip
done
