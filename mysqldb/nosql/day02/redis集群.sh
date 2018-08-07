#搭建redis集群
#
#关系型数据库：RDBMS
#nosql 泛指非关系型数据库，不需要预先定义数据结构（内存存储）  
#常用的软件
#Redis   分布式内存数据库   支持数据持久化的 NoSQL 数据库服务软件
#mongoDB 
#couchdb neo4j flockdb
#安装软件  /编译安装
tar -xf  redis-4.0.8.tar.gz 
yum -y  install gcc  c++
make &&   make  install
#初始化   redis 服务
cd  /root/redis/utils
./install_server.sh
#默认数据库目录 /var/lib/redis/6379/*
#配置文件   /etc/redis/6379.conf
#日志文件  /var/log/redis_6379.log
#默认端口  /var/log/redis_6379.log
#服务名称 : /usr/local/bin/redis-server
#查看端口    ss  -nutpl | grep :6379    
#查进程      ps  -C  redis-server
#启动服务    /etc/init.d/redis_6379   start
#关闭服务    /etc/init.d/redis_6379   start
#进入数据库   redis-cli
set  name  bob  #存入数据
get  name       #取出数据
ls  /var/lib/redis/6379/dump.rdb   #默认数据存储路径
默认支持 16个库  编号{0~15}
切换库:  select 1  /  select 15 
查询所有存储值:  keys *
del+变量名   	#//删除当前变量   
flushall  	#//删除所有变量
save 		#// 保存变量        
shutdown 	#//关闭服务  
#部署 LNMP  平台   支持动静分离
 cd lnmp_soft/
 tar -xf nginx-1.12.2.tar.gz 
 cd nginx-1.12.2/
 yum -y install gcc   pcre-devel openssl-devel
 ./configure 
 make && make install
 yum -y install php-mysql 
 yum -y install php-fpm
 
#启动 nginx 服务     启动 php-fpm 服务 
  systemctl restart mysqld

  systemctl stop httpd
  /usr/local/nginx/sbin/nginx
  vim /usr/local/nginx/conf/nginx.conf
  /usr/local/nginx/sbin/nginx -s reload

  systemctl start php-fpm
 
  firefox http://127.0.0.1/test.php
 
  firefox http://192.168.4.50/test.php
  service redis_6379 stop
#配置 PHP 支持 Redis
 yum -y install  php-devel-5.4.16-42.el7.x86_64.rpm
 vim  /usr/local/nginx/html/redis.php
		<?php
		$redis = new redis();
		$redis->connect('127.0.0.1',6379);
		$redis->set('redistest','666666');
		echo $redis->get('redistest');
		?>
#验证能识别  
firefox 192.168.4.50/redis.php    
#修改redis配置文件  
]# vim  /etc/redis/6379.con
 70 bind 192.168.4.50 127.0.0.1
 93 port 6350
#port 6379 		 //端口
#bind 127.0.0.1	 //IP 地址
#tcp-backlog 511 	//tcp 连接总数
#timeout 0 		// 连接超时时间
#tcp-keepalive 300	// 长连接时间
#daemonize yes 	// 守护进程方式运行
#databases 16 	// 数据库个数
#logfile /var/log/redis_6379.log 	//pid 文件
#maxclients 10000 			// 并发连接数量
#dir /var/lib/redis/6379 		// 数据库目录

/etc/init.d/redis_6379 stop    	#//关闭服务
/etc/init.d/redis_6379 start   	#//重起服务
redis-cli -h 192.168.4.50 -p 6350   #登陆服务
redis-cli -h 192.168.4.51 -p 6350  shutdown   #关闭服务
#修改脚本自动停止服务
vim  /etc/init.d/redis_6379
	REDISPORT="6350"
	$CLIEXEC -h 192.168.4.51 -p $REDISPORT shutdown

#内存清除策略
#volatile-lru 最近最少使用 (针对设置了过期时间的 key )
#
#allkeys-lru 删除最少使用的 key
#volatile-random 在设置了过期的 key 里随机移除
#allkeys-random 随机移除 key
#volatile-ttl (minor TTL) 移除最近过期的 key
#noeviction
#不删除 写满时报错
#选项默认设置
#maxmemory <bytes> 		#// 最大内存
#maxmemory-policy noeviction 	#// 定义使用的策略
#maxmemory-samples 5 		#// 选取模板数据的个数
#设置数据库的密码
 vim /etc/redis/6379.conf   	#//设置数据库的密码
requirepass 123456  	#//501行      
#进入数据库：
redis-cli -h 192.168.4.51 -p 6350 -a 123456
#设置脚本关闭服务   
vim  /etc/init.d/redis_6379
	 stop )
	...
	   $CLIEXEC -h 192.168.4.51 -p $REDISPORT -a 123456 shutdown
#管理数据库的常用命令： 
#set(添加)   get(查看数据) del(删除数据)  move(移动变量)  flushall // 删除所有变量   save // 保存变量
"配置Redis集群步骤"
1.准备 6台 redis 服务器
2"配置Redis集群"
2.1在每台redis服务器配置集群配置，然后重起服务
vim  /etc/redis/6379.conf
	cluster-enabled yes			#//启用配置集群,  815行   
	cluster-config-file nodes-6350.conf	#//存储集群的名字,  823行 
	cluster-node-timeout 5000		#//通信的超时时间15000,  829行
	port 6350 					#//默认端号6379,  93行
	bind 127.0.0.1  192.168.4.50	  	#//默认IP,  70行
#2.2创建集群
#2、创建集群
	#2.1 安装ruby环境运行包
	yum -y install  ruby   rubygems
	rpm -ivh --nodeps  ruby-devel-2.0.0.648-30.el7.x86_64.rpm
	gem  install redis-3.2.1.gem

	#2.2 把ruby复制到
	cp  /redis-4.0.8/src/redis-trib.rb  /usr/local/sbin/

	#2.3 创建集群    保证数据库里没有数据
	redis-trib.rb  create  --replicas 1  192.168.4.51:6351 192.168.4.52:6352 192.168.4.53:6353 192.168.4.54:6354 192.168.4.55:6355 192.168.4.56:6356

#>>> Creating cluster
#>>> Performing hash slots allocation on 6 nodes...     #//hash值要在6台上去键
#Using 3 masters:	#//三台主库是
#192.168.4.51:6351
#192.168.4.52:6352
#192.168.4.53:6353
#Adding replica 192.168.4.55:6355 to 192.168.4.51:6351		#//55是51的从
#Adding replica 192.168.4.56:6356 to 192.168.4.52:6352		#//56是52的从
#Adding replica 192.168.4.54:6354 to 192.168.4.53:6353
#M: cf0b6920f39fc02d02aa5c12b718399642bf254a 192.168.4.51:6351
#   slots:0-5460 (5461 slots) master					#//主库的hash曹范围0～5460，共5461个，从库不分配hash曹值
#M: 7c7c23a529df8dc8ada1838cfee70e66fe92dafa 192.168.4.52:6352
#   slots:5461-10922 (5462 slots) master
#M: d226e49cb0c8ae38e545f19cac7b458855fe0e19 192.168.4.53:6353
#   slots:10923-16383 (5461 slots) master
#S: 5ae7643a95578e1c588b5d7eafe932b22f9e4501 192.168.4.54:6354
#   replicates d226e49cb0c8ae38e545f19cac7b458855fe0e19
#S: b6aa43fb63059cc19220ee7f13048d5997317985 192.168.4.55:6355
#   replicates cf0b6920f39fc02d02aa5c12b718399642bf254a
#S: 504ba16af746a361f4e721e3082dd05e34335483 192.168.4.56:6356
#   replicates 7c7c23a529df8dc8ada1838cfee70e66fe92dafa
#Can I set the above configuration? (type 'yes' to accept): yes
#>>> Nodes configuration updated
#>>> Assign a different config epoch to each node
#>>> Sending CLUSTER MEET messages to join the cluster
#Waiting for the cluster to join...
#>>> Performing Cluster Check (using node 192.168.4.51:6351)
#M: cf0b6920f39fc02d02aa5c12b718399642bf254a 192.168.4.51:6351
 #  slots:0-5460 (5461 slots) master						#//
#   1 additional replica(s)
#M: d226e49cb0c8ae38e545f19cac7b458855fe0e19 192.168.4.53:6353
#   slots:10923-16383 (5461 slots) master
#   1 additional replica(s)
#S: b6aa43fb63059cc19220ee7f13048d5997317985 192.168.4.55:6355
#   slots: (0 slots) slave
#   replicates cf0b6920f39fc02d02aa5c12b718399642bf254a
#S: 504ba16af746a361f4e721e3082dd05e34335483 192.168.4.56:6356
#   slots: (0 slots) slave
#   replicates 7c7c23a529df8dc8ada1838cfee70e66fe92dafa
#M: 7c7c23a529df8dc8ada1838cfee70e66fe92dafa 192.168.4.52:6352
#   slots:5461-10922 (5462 slots) master
#   1 additional replica(s)
#S: 5ae7643a95578e1c588b5d7eafe932b22f9e4501 192.168.4.54:6354
#   slots: (0 slots) slave
#   replicates d226e49cb0c8ae38e545f19cac7b458855fe0e19
#[OK] All nodes agree about slots configuration.
#>>> Check for open slots...
#>>> Check slots coverage...
#[OK] All 16384 slots covered.		#//hash槽的总数是16384个，范围0～16383

查看配置文件查看集群信息
cat  /var/lib/redis/6379/nodes-6379.conf

#测试集群
#任意一台主机访问本机的 redis 服务,查看即可: redis-cli -c -h IP地址 -p 端口
#> cluster nodes # 查看本机信息
#> cluster info  # 查看集群信息

集群的工作原理

#管理集群
#管理命令 redis-cli    redis-trib.rb 脚本
#redis-cli命令查看命令帮助
#	– redis-cli -h
#	#常用选项
#	– -h IP 地址
#	– -p 端口

#	– -c 访问集群
#redis-trib.rb脚本语法格式
#	 – Redis-trib.rb  选项 参数
#	#选项
# 	– add-node 添加新节点
#	– check 对节点主机做检查
#	– reshard 对节点主机重新分片
#	– add-node --slave 添加从节点主机
#	– del-node 删除节点主机

#向群中添加redis服务器  50主  57从   58从   
客户端远程访问集群 ：
[root@host50 ~]# redis-cli  -c -h 192.168.4.51  -p 6351 
[root@host50 ~]# redis-cli  -c -h 192.168.4.52  -p 6352 
[root@host50 ~]# redis-cli  -c -h 192.168.4.53  -p 6353   #//当一个主服务器宕机后，还有备用，体现高可用，

#把某个master角色主服务器宕机后，还有备用，体现高可用
#当主服务器52挂掉后，56从库会顶上。当一组服务器全挂掉了 集群就会坏了，数据旧丢失了
#解决办法一组多从
#51上执行脚本检查当前集群的状态：redis-trib.rb   check  192.168.4.51:6351

#向集群添加新的服务器
	#运行redis 服务，  清除已有的数据   ，做启用集群配置后  重起服务
	[root@host50 ~]# ss -nutlp | grep redis 
	[root@host50 ~]# rm -rf  /var/lib/redis/6379/*
	[root@host50 ~]# vim /etc/redis/6379.conf
	[root@host50 ~]# vim /etc/init.d/redis_6379 
	[root@host50 ~]# /etc/init.d/redis_6379  start
	[root@host50 ~]# ss -nutlp | grep redis 
	[root@host50 ~]# redis-cli -h 192.168.4.50 -p 6350
	#添加master 角色主机
	#1、准备条件：配置redis服务器，打开redis集群服务
	[root@host51 ~]# redis-trib.rb  check 192.168.4.51:6351		#//集群中查看是否添加成功
	[root@host51 ~]# redis-trib.rb  add-node 192.168.4.50:6350  192.168.4.51:6351     #//添加主库，创建失败

	[root@host51 ~]# redis-trib.rb  reshard  192.168.4.51:6351	#//集群中重新分片规则
	[root@host51 ~]# redis-trib.rb  check 192.168.4.51:6351		#//集群中查看是否添加成功，是否有hash槽值
	#添加salve角色主机
	#准备条件：配置redis服务器，打开redis集群服务

#
#移除节点移除主节点
#删除槽位
[root@host51 ~]# redis-trib.rb reshard 192.168.4.51:6351
#	1 、移动多少个哈希值
#	2、接收hash  slots  主机的id
#	3、done /all  done
#	4、yes 提交
#	3、移出hash  slots  主机的id
#	4、删除主节点
#• 移除主节点
# 格式：redis-trib.rb del-node 192.168.4.51:6351 被移除节点主机id
[root@host51 ]# redis-trib.rb del-node 192.168.4.51:6351 f6649ea99b2f01faca26217691222c17a3854381	#//移除从节点id
#• 从节点主机没有槽位范围,直接执行移除命令即可
#
#– redis-trib.rb del-node 192.168.4.51:6351 被移除主机的 ID
#]#redis-trib.rb del-node 192.168.4.51:6351 c82d27e870a8dd628ea26939bbd4bd0ee036c70e
