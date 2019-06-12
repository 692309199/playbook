#!/bin/bash
file_list='.netrc .rhosts hosts.equiv'
for filename in $file_list
do
        files=`find / -maxdepth 3 -name $filename 2>/dev/null`
        for file in $files
        do
                echo $file
                [[ $file != "" ]] && cp $file $file".bak"  && rm $file 
        done
done
echo "success"
