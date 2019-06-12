#!/bin/bash

#参数
bond_type=$1
miimon=$2
bond_name="bond"$bond_type
real1_name=$3
real2_name=$4
cfg_file_path='/etc/sysconfig/network-scripts/'
bond_config_file="ifcfg-"$bond_name
real_config_file1="ifcfg-"$real1_name
real_config_file2="ifcfg-"$real2_name
ipaddress=$5
PREFIX=$6
GATEWAY=$7
DNS1=$8
DNS2=$9
bonding_modules="/etc/sysconfig/modules/bonding.modules"

#备份文件
now_time=`date +"%Y%m%d%H%M%S" `
[[ -f $cfg_file_path$bond_name ]] && cp $cfg_file_path$bond_name $cfg_file_path$bond_name$now_time
[[ -f $cfg_file_path$real1_name ]] && cp $cfg_file_path$real1_name $cfg_file_path$real1_name$now_time
[[ -f $cfg_file_path$real2_name ]] && cp $cfg_file_path$real2_name $cfg_file_path$real2_name$now_time

(
cat <<EOF
BOOTPROTO=static
#DEVICE=$bond_name
DEVICE=bond0
NAME=bond_name
TYPE=Bond
BONDING_MASTER=yes
ONBOOT=yes
IPADDR=$ipaddress
PREFIX=$PREFIX
GATEWAY=$GATEWAY
DNS1=$DNS1
DNS2=$DNS2
EOF
) > $cfg_file_path$bond_config_file

(
cat <<EOF
TYPE=Ethernet
BOOTPROTO=none
DEVICE=$real1_name
NAME=$real1_name
ONBOOT=yes
#MASTER=$bond_name
MASTER=bond0
SLAVE=yes
EOF
) > $cfg_file_path$real_config_file1

(
cat <<EOF
TYPE=Ethernet
BOOTPROTO=none
DEVICE=$real2_name
NAME=$real2_name
ONBOOT=yes
#MASTER=$bond_name
MASTER=bond0
SLAVE=yes
EOF
) > $cfg_file_path$real_config_file2


#如果没有则创建
[[ -f $bonding_modules ]]  && cp $bonding_modules  /etc/sysconfig/modules/bonding.modules_$now_time  
[[ -f $bonding_modules ]] || touch $bonding_modules 
echo "modprobe bonding mode=$bond_type miimon=$miimon" >  $bonding_modules
chmod +x  /etc/rc.d/rc.local
config_count=`grep "^modprobe bonding" /etc/rc.d/rc.local | wc -l`
[[ $config_count -eq 0 ]] && echo "modprobe bonding" >> /etc/rc.d/rc.local
modprobe bonding
systemctl restart network
