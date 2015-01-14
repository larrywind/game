--建库
CREATE DATABASE `db_chuzzle_test` DEFAULT CHARACTER SET utf8;

--rename database
--shell
#!/bin/bash

mysqlconn="mysql -ukok3hefu -pkok3hefu --default-character-set=latin1 -S /data1/mysqldata/mysql.sock -h localhost"
olddb=O_NAME
newdb=N_NAME

$mysqlconn -e "CREATE DATABASE $newdb"
params=$($mysqlconn -N -e "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE table_schema='$olddb'")

for name in $params; do
    $mysqlconn -e "RENAME TABLE $olddb.$name to $newdb.$name";
done;

$mysqlconn -e "DROP DATABASE $olddb"

--建表1
CREATE TABLE IF NOT EXISTS UpstateTeanaMusic
(
	iEventId bigint unsigned comment '游戏事件ID',
	vZoneId varchar(25) comment '登录的zone（分线）编号',
	dtEventTime datetime comment '操作时间, 格式 YYYY-MM-DD HH:MM:SS',
	iSequence bigint unsigned comment '日志事件的序列号',
	iUin int unsigned comment '用户QQ号',
	vRoleName varchar(64) comment '角色名',
	iGender tinyint comment '角色性别',
	iRoleLevel int comment '角色等级',
	iNumber smallint comment '属性序号',
	iWorthNew int comment '领悟后乐谱战力',
	iStateNew smallint comment '领悟后乐谱境界',
	iSvrId int comment '大区ID',
	INDEX(iUin),
	INDEX(dtEventTime)
)ENGINE=InnoDB comment '天籁之音乐谱领悟日志'

--建表2
CREATE TABLE IF NOT EXISTS `tb_chuzzle_onlinecnt` (
  `gameappid` varchar(32) NOT NULL DEFAULT '0' COMMENT '游戏ID',
  `timekey` int NOT NULL DEFAULT '0' COMMENT '当前时间除以秒，下取整做为key',
  `gsid` varchar(32) NOT NULL COMMENT 'gamesvrid',
  `zoneid` int NOT NULL DEFAULT '0' COMMENT '分区分服填写分区id，唯一标示一个区，非全区全服填写0',
  `onlinecntios` int NOT NULL DEFAULT '0' COMMENT 'ios在线人数',
  `onlinecntandroid` int NOT NULL DEFAULT '0' COMMENT 'android在线人数',
  PRIMARY KEY(`gameappid`,`timekey`,`gsid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='实时在线表';

--rename table
rename table tbl1 to tbl2;

--添加字段
alter table Pourexp add column vActionId varchar(64) comment '动作ID';
alter table UpstateTeanaMusic add column gameappid varchar(32) NOT NULL DEFAULT '0' COMMENT '游戏ID'

--数据统计
 mysql -uyw -pyw db_begonia_logdb_$worldid -e "select distinct vOpenID,sum(iMoney) from MoneyFlow where iReason=0 and iSubReason=28 and dtEventTime between '2014-06-23 00:00:00' and '2014-06-23 23:59:59' group by vOpenID;"
 
 --union
mysql -uyw -pyw KOK_DB_29 -e 'select b.QQUIN,b.CHARID,a.NAME,a.LEVEL,a.MASTER,from_unixtime(a.CREATETIME) from `UNION` as a ,CHARBASE as b where a.CHARID=b.CHARID and from_unixtime(a.CREATETIME) > "2013-06-28 00:00" and from_unixtime(a.CREATETIME) < "2013-07-08 00:00" order by LEVEL desc limit 10;'
 mysql -uyw -pyw db_kok3_logdb_5 -Bse "select a.dtOpTime,a.iUin,b.iRoleId,b.vRoleName,a.iPay from ChongZhi as a,MoneyFlow as b where b.iUin=a.uDstUin;"

 --select -insert
 mysqldump -uroot -t -c -w"NAME='test333'" KOK_DB CHARBASE > test.sql
 
 --insert
 INSERT INTO `nx_market_quest_map`(`contractId`, `step`, `questId`) VALUES ('438T320141022144834', 2, 'quest-999998'),('438T320141022144834', 3, 'quest-999999');
 
 --dump
 mysqldump -uyw -pyw -R --single-transaction --default-character-set=utf8  --skip-opt  -q --create-option --no-autocommit -B qq9x_${dbname} | gzip -c > /data/backup/qq9x_${dbname}_${Date}.sql.gz

 --导入
mysql -umingli -pmingli --default-character-set=utf8 -f< ${DBNAME}_${time}.sql 2>err_${DBNAME}.log