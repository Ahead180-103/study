mysql主从同步
mysql主从同步模式

mysql主从同步介绍：

角色分为两种：
数据库服务 做主master库：
数据库服务 做从slave库：

192.168.4.51  192.168.4.52
  master	slave


主库配置步骤
1、启用binlog日志
 vim /etc/my.cnf
[mysqld]
validate_password_policy=0
validate_password_length=6
server_id=51
log-bin=master51
binlog-format="mixed"
:wq

[root@host51 ~]# systemctl restart  mysqld     
[root@host51 ~]#  ls /var/lib/mysql/master51.*   #查看是否有

2、用户授权
mysql> grant replication slave on *.* to repluser@"192.168.4.52" identified by "123456";
3、查看正在使用的binlog日志信息
mysql> show master status;

从库配置步骤
1、验证授权信息
]# mysql -h192.168.4.51 -urepluser -p123456
2、指定server_id
]# vim /etc/my.cnf
[mysqld]
server_id=52
3、指定主库信息
]# mysql -uroot -p123456
mysql> change master to 	
     ->master_host="192.168.4.51",   #//主库ip
     ->master_user="repluser",		#//授权用户名
     ->master_password="123456",	#//授权用户名密码
     ->master_log_file="master51.000001",	#//主库的binlog日志
     ->master_log_pos=154;			#//主库的偏移量
mysql> start slave;
4、查看从库状态信息
mysql> show slave status\G ;
		Slave_IO_Running: Yes	#//复制 master主机 binlog日志文件里的SQL到本机的relay-log文件里。
		Slave_SQL_Running: Yes	#//执行本机relay-log文件里的SQL语句,重现 Master的数据操作。
mysql> show master status ;
mysql> show processlist;
工作原理
master.info
relay-log.info
host52-relay-bin.xxxxxx   中继日志文件
host52-relay-bin.index
客户端验证主从同步配置

]# mysql -uroot -p123456 
mysql> 
主从配置常用参数

主库配置

主从从  把主机53配置为52从库。
配置主库：192.168.4.52
启用binlog日志
用户授权

配置从库：192.168.4.53
1、 验证主库授权用户
2、指定server_id
3、
4、


