#!/bin/bash

#USE：批量查询IP归属地和运营商

#通过写一个for循环，控制每次需要批量操作的次数，
#然后封装一个方法，方法里进行批量操作，并将此方法用&符号放在后台运行
#每个循环结束前用wait函数，确保当前批量处理操作全部完成


#开始时间
begin=$(date +%s)
#IP文件
sfile=indeed.txt
#处理后文件
dfile=rel.txt

#执行目录
root_dir="/data/qq9x"

if [ ! -d $root_dir ]; then
	mkdir -p $root_dir
fi
cd $root_dir

#批量查询IP函数
function create_dir()
{

	curl -s http://api.ipdb.gslb.oa.com:8555/d?ip=$1 |iconv -fgbk -tutf-8 |awk '{print $1,$2,$3,$6}' >>$dfile
}

#总记录数
count=`cat indeed.txt  |wc -l`
#并发数
rsnum=400
#次数
cishu=$(expr $count / $rsnum)
#创建数组
a=`cat $sfile`
b=($a)

#开始并发
for ((i=0; i<$cishu;))
do
	start_num=$(expr $i \* $rsnum)
	end_num=$(expr $start_num + $rsnum - 1)
	for j in `seq $start_num $end_num`
	do
		create_dir ${b[$j]} &
	done
	wait
	i=$(expr $i + 1)
done

#余数
yushu=$(expr $count % $rsnum)
start_num=$[ $j + 1 ]
end_num=$(expr $j + $yushu)
for m in `seq $start_num $end_num`
do
	create_dir ${b[$m]} &
done
wait

echo $m $end_num

#结束时间
end=$(date +%s)
spend=$(expr $end - $begin)
echo "time is $spend"
