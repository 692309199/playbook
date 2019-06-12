#!/bin/bash

#参数
install_path=$1
install_file=$2
pacth_file_path=$3
pacth_file=$4
#补丁对比
diff -uN $install_path$install_file $pacth_file_path$pacth_file > /tmp/diff_result
cd $install_path && patch -p0 $install_file /tmp/diff_result
rm -f $pacth_file_path$pacth_file
rm -f /tmp/diff_result
rm -f  /tmp/$0
