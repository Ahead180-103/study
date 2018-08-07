#关系型数据库  ：mysql  sql server
#非关系型数据库：redis   mongodb  Memcached   CouchDB Neo4j  FlockDB
#

#Redis 特点:
	#支持数据持久化,可以把内存里数据保存到硬盘中
	#不仅仅支持 key/values 类型的数据,同时还支持 list hash set zset 类型
 	#支持 master-salve 模式数据备份

# 1、源码安装redis包
[root@host50 ~]# 	tar -xzf redis-4.0.8.tar.gz
[root@host50 redis-4.0.8]# cd redis-4.0.8
[root@host50 redis-4.0.8]# make
[root@host50 redis-4.0.8]# make install
# 2、初始化配置
#	./utls/install_server.sh // 初始化
#	
#
#
解决依赖关系 yum -y install php-devel-5.4.16-42.el7.x86_64.rpm 
 ls 
 tar -xf php-redis-2.2.4.tar.gz 
 cd phpredis-2.2.4
[root@bogon phpredis-2.2.4]# which phpize  
[root@bogon phpredis-2.2.4]# phpize
[root@bogon phpredis-2.2.4]# ls /usr/bin/php-config 
[root@bogon phpredis-2.2.4]# ls
[root@bogon phpredis-2.2.4]# ./configure --with-php-config=/usr/bin/php-config
[root@bogon phpredis-2.2.4]# make  && make install

 #安装路径/usr/lib64/php/modules/
[root@bogon phpredis-2.2.4]# vim /etc/php.ini
	修改前728行和730行
	; extension_dir = "./"
	; extension = "ext"
	修改后
	extension_dir = "/usr/lib64/php/modules/"
	; On windows:
	extension = "redis.so"



