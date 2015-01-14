#!/bin/sh

count=0
cat indeed.txt |while read line
do
    dip=`echo $line |awk -F. '{print $1"."$2"."$3}'`
	cat ipdb2.data  |grep -w $dip |iconv -fgbk -tutf-8 |awk '{print "'$line'",$2,$3,$6}' >>rel.txt
	count=$[ $count + 1 ]
done
echo $count