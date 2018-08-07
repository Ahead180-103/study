Mongodb副本集:
MongoDB 复制是将数据同步在多个服务器的过程。
– 复制提供了数据的冗余备份,并在多个服务器上存储
数据副本,提高了数据的可用性, 并可以保证数据的
安全性。
– 复制还允许您从硬件故障和服务中断中恢复数据
创建
vim mongodb.conf
logpath=/usr/local/mongodb/log/mongodb.log
logappend=true
dbpath=/usr/local/mongodb/data/db
fork=true
bind_ip=192.168.4.55
port=27055
replSet=rs1
启动服务
mongod   -f /usr/local/mongodb/etc/mongodb.conf 

查看服务信息

连接服务
mongo  --host  192.168.4.51  --port 27051
创建集群 
mongo  --host  192.168.4.51  --port 27051
> config = {
_id:"rs1",
members:[
{_id:0,host:"192.168.4.51:27051"},
{_id:1,host:"192.168.4.52:27052"},
{_id:2,host:"192.168.4.53:27053"}]
};


rs1:SECONDARY> rs.status()   #//查看集群状态
rs1:PRIMARY> rs .isMaster()  #//查看集群谁是主库
rs1:PRIMARY> db.getMongo().setSlaveOk()  #//允许从库查看数据

