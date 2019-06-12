#!/bin/bash

#参数
bond_type=$1
miimon=$2
bond_name="bond"$bond_type
cfg_file_path='/etc/sysconfig/network-scripts/'
bond_config_file="ifcfg-"$bond_name
ipaddress=$3
PREFIX=$4
GATEWAY=$5
DNS1=$6
DNS2=$7
bonding_modules="/etc/sysconfig/modules/bonding.modules"

#ifcfg配置文件备份文件夹
backup_dir="/etc/sysconfig/network-scripts/backup/"

[[ -d $backup_dir ]] || mkdir -p $backup_dir

#判断DNS2是否有传入参数,否则赋空值
[[ $DNS2 == "0" ]] && DNS2=""

#备份文件
now_time=`date +"%Y%m%d%H%M%S" `
[[ -f $cfg_file_path$ifcfg-$bond_name ]] && cp $cfg_file_path$ifcfg-$bond_name $backup_dir$ifcfg-$bond_name$now_time

#绑定bond0
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

#绑定网卡
count=0
for i in $*
do 
	count=`expr $count + 1`
	if [[ $count -gt 7 ]]; then
		config_file=ifcfg-$i
		[[ -f $cfg_file_path$config_file ]] && cp $cfg_file_path$config_file $backup_dir$config_file$now_time
		(
cat <<EOF
TYPE=Ethernet
BOOTPROTO=none
DEVICE=$i
NAME=$i
ONBOOT=yes
MASTER=bond0
SLAVE=yes
EOF
) > $cfg_file_path$config_file
	fi
done


#如果没有则创建
[[ -f $bonding_modules ]]  && cp $bonding_modules  /etc/sysconfig/modules/bonding.modules_$now_time  
[[ -f $bonding_modules ]] || touch $bonding_modules 
echo "modprobe bonding mode=$bond_type miimon=$miimon" >  $bonding_modules
chmod +x  /etc/rc.d/rc.local
config_count=`grep "^modprobe bonding" /etc/rc.d/rc.local | wc -l`
[[ $config_count -eq 0 ]] && echo "modprobe bonding" >> /etc/rc.d/rc.local
modprobe bonding
systemctl restart network
rm -f $0
