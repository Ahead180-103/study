#redis 创建一主一从
#
#环境：部署两台redis服务器，必须关掉集群配置
#       主机host50  host57
#	主库host50    从库host57
#配置从库 192.168.4.57/24
#– redis 服务运行后,默认都是 master 服务器
#– 修改服务使用的 IP 地址 bind 192.168.4.X   port 63X
  [root@ host50 ~]# redis-cli -h 192.168.4.50  -p 6350  
  192.168.4.50:6350> info replication  		#// 查看主从配置信息
  
  [root@ host50 ~]# redis-cli -h 192.168.4.57  -p 6357  
  192.168.4.57:6357> info replication  		#// 查看主从配置信息
  192.168.4.57:6357> SLAVEOF 192.168.4.57 6357	#//命令行指定主库：SLAVEOF 主库 IP 地址 端口号


#永久主从同步且带认证的（同步数据时需要设置密码）
host50
[root@ host50 ~]# vim /etc/redis/6379.conf
#501 requirepass  123456
[root@ host50 ~]# vim /etc/init.d/redis_6379
$CLIEXEC -h 192.168.4.50 -p $REDISPORT -a 123456 shutdown


host57
[root@host57 ~]# /etc/init.d/redis_6379 stop
[root@host57 ~]# sed -n '282p;289p'  /etc/redis/6379.conf
slaveof 192.168.4.50   6350 
#masterauth 123456
[root@host57 ~]# redis-cli -h 192.168.4.57 -p 6357  
192.168.4.57:6357> info replication 

host58
[root@host58 ~]# /etc/init.d/redis_6379 stop
[root@host58 ~]# sed -n '282p;289p'  /etc/redis/6379.conf
slaveof 192.168.4.57   6350 
#masterauth 123456
[root@host57 ~]# redis-cli -h 192.168.4.57 -p 6357  
192.168.4.57:6357> info replication 
#哨兵模式
#• 哨兵模式
#– 主库宕机后,从库自动升级为主库
#– 在 slave 主机编辑 sentinel.conf 文件
#– 在 slave 主机运行哨兵程序
[root@redis52 ~]# vim /etc/sentinel.conf
sentinel monitor host51 192.168.4.50 6350 1
:wq
[root@redis52 ~]# redis-sentinel /etc/sentinel.conf
#sentinel monitor 主机名 ip 地址 端口 票数
#主机名:自定义
#IP 地址: master 主机的 IP 地址
#端 口: master 主机 redis 服务使用的端口
#票 数:主库宕机后, 票数大于 1 的主机被升级为主库
#



Redis 持久化

RDB/AOF
相关配置参数
#文件名
#dbfilename "dump.rdb" // 文件名
#save  ""	#// 禁用 RDB
#数据从内存保存到硬盘的频率
#
#save 900 1 	#// 900 秒内且有 1 次修改存盘
#save 300 10	#//300 秒内且有 10 次修改存盘
#save 60 10000	#//60 秒内且有 10000 修改存盘
#
#手动立刻存盘
#
#> save	#// 阻塞写存盘
#> bgsave 	#// 不阻塞写存盘
#相关配置参数 ( 续 1)
• 压缩
– rdbcompression yes | no

• 在存储快照后,使用 crc16 算法做数据校验
– rdbchecksum yes|no
• bgsave 出错停止写操作 , 对数据一致性要求不高设置为 no
– stop-writes-on-bgsave-error yes|no

#RDB 优点
#1、持久化时, Redis 服务会创建一个子进程来进行持久化,会先将数据写入到一个临时文件中,待持久化过程都结束了,再用这个临时文件替换上次持久化好的文件;整个过程中主进程不做任何 IO 操作,这就确保了极高的性能。
#2、如果要进程大规模数据恢复,且对数据完整行要求不是非常高,使用 RDB 比 AOF 更高效。
#RDB 的缺点
#1、意外宕机,最后一次持久化的数据会丢失。


AOF 介绍   #//类似mysql的binlog日志文件
• 只追加操作的文件
– Append Only File
– 记录 redis 服务所有写操作。
– 不断的将新的写操作,追加到文件的末尾。
– 使用 cat 命令可以查看文件内容

相关配置参数'在配置文件中查找/etc/redis/6379.conf'
• 文件名
– appendfilename "appendonly.aof"  	#// 文件名
– appendonly yes 				#// 启用 aof,默认 no

• AOF 文件记录,写操作的三种方式
– appendfsync always 	 #// 有新的写操作立即记录,性能差,完整性好。
– appendfsync everysec	 #// 每秒记录一次,宕机时会丢失 1 秒的数据
– appendfsync no      	 #// 从不记录

#redis数据类型
string
list
hash



