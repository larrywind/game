#!/bin/bash
# SCRIPT: ptest.sh
# AUTHOR: Ray001
# DATE: 2008/10/03
# REV: 2.0
# For STUDY
#
# PURPOSE:
# 实现进程并发，提高执行效率，同时能记录每个执行失败的子进程信息


#定义并发进程数量
PARALLEL=100
#定义临时管道文件名
TMPFILE=$$.fifo
#定义导出配置文件全路径名
CMD_CFG=/data/qq9x/end.txt
#定义失败标识文件
FAILURE_FLAG=failure.log


####################### 函数定义 ########################
# 中断时kill子进程
function trap_exit
{
kill -9 0
}


# 通用执行函数
exec_cmd()
{
    # 此处为实际需要执行的命令，本例中用sleep做示例
    curl -s http://api.ipdb.gslb.oa.com:8555/d?ip=${1} |iconv -fgbk -tutf-8 |awk '{print $1,$2,$3,$6}' >>rel2.txt
    if [ $? -ne 0 ]
    then
        echo "命令执行失败"
        return 1
    fi
}


trap 'trap_exit; exit 2' 1 2 3 15

#清理失败标识文件
rm -f  ${FAILURE_FLAG}

#为并发进程创建相应个数的占位
mkfifo $TMPFILE 
exec 4<>$TMPFILE 
rm -f $TMPFILE 
{ 
        count=$PARALLEL
        while [ $count -gt 0 ]
        do 
                echo
                let count=$count-1
        done 
} >&4
 
#从任务列表 seq 中按次序获取每一个任务 
while read SEC 
do 
        read <&4
         (  exec_cmd ${SEC} || echo ${SEC}>>${FAILURE_FLAG} ; echo >&4 ) &
done<$CMD_CFG
wait 
exec 4>&- 

#并发进程结束后判断是否全部成功
if [ -f ${FAILURE_FLAG} ]
then
        exit 1
else
        exit 0
fi