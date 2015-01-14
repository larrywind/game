#!/bin/bash

cd /data/logs

for i in `find ./9.1.3.* -type f`
do
    cat $i | grep address |awk  '{print $11}' | awk -F: '{print $1}' |sed s/'<'//g | egrep -v '^10.+$' >>conn_all.txt
done	