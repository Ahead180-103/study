#MySQL 读写分离
#MySQL 多实例
#MySQL 性能调优
#
#mysql性能调优
#
#1.1 mysql  服务的工作过程
#管理工具：mysql服务软件安装后提供的命令
#连接池：检查本纪是否有资源处理当前的连接请求，资源处理（）
#sql接口：把sql命令传递给服务的进程处理
#sql分析器：检查执行sql命令是否正确，是否有语法错误
#优化器：优化执行的sql命令，使其能以最节省系统资源的方式执行。
#
#查询缓存：查询缓存的存储空间是系统的物理内存里面自动划分出来的存储 空间，用来存储查询出来的数据
#存储引擎：软件自带的功能程序，是用来处理比表的处理器
#
#
#mysql优化
#数据库服务器处理客户的连接请求慢，可能是由那些原因导致
#网络宽带
#服务器的配置：查看服务器硬件资源的使用情况，  cpu（多核 进程 ）  内存   存储（磁盘的转速  I/O ）
#提供数据服务软件版本底
#查看服务软件时的参数设置
mysql> show variables;   #//查看参数
#模糊查找参数
#格式：show variables like "%关键字%"；
mysql> show variables like "%time%";

#帮助文档
#mysql帮助手册
#mysql配置文件详解
#修改命令行修改

mysql> show variables like "%max_connection%";  #//查看并发量
mysql> set global max_connections=500;  	#//因为是全局变量，所以要加global

#有过的最大的连接数量/并发连接数=0.85	Max_used_connections/max_connections=0.85
mysql> show global status like "%conne%"；  #//模糊查看并发连接数的最大数
#//并发连接数的最大数	Max_used_connections

mysql> flush status;  #//刷新连接数，清空源记录

mysql> show variables like "%thread%";	#//模糊查看线程数量
#可以重复使用的线程的数量 thread_cache_size  =9

mysql> show variables like "%table%";   #//模糊查看为所有线程缓存的打开的表的数量
#table_open_cache                       | 2000 #//为所有线程缓存的打开的表的数量2000个

# key_buffer-size 用于 MyISAM 引擎的关键索引缓存大小
# index, primary key,  foreign key

#查看数据库缓存操作

#当对myisam存储引擎的表，查询的时候，若此时有客户端对表执行写操作，mysql服务不会从缓存里查找数据返回给客户端，而是等写操作完成，重新从新表里面查找数据给客户端。

#uery_cache_wlock_invalidate 查询缓存写锁无效是否开了

#查询缓存统计信息
 mysql> show global status like "%qcache%";
#Qcache_not_cached       //查询结果不让往缓存放的次数
+--------------------------------------------+----------------+
| Variable_name           | Value   |
+--------------------------------------------+----------------+
| Qcache_free_blocks      | 1       |
| Qcache_free_memory      | 1031832 |
| Qcache_hits             | 0       |
| Qcache_inserts          | 0       |
| Qcache_lowmem_prunes    | 0       |
| Qcache_not_cached       | 2       |
| Qcache_queries_in_cache | 0       |
| Qcache_total_blocks     | 1       |
+--------------------------------------------+----------------+
#程序员编写的访问数据库服务数据的sql命令复杂，导致处理速度。
#方法：在数据库服务器上启用man查询日志，记录超过指定时间显示查询结果的sql命令
#binlog日志    错误日志
#查询日志：记录所有的sql命令
#启用日志文件
  
#man查询日志：只记录超时时间显示查询结果的sql命令
#ls /var/log/mysqld.log //错误的日志文件
#配置文件中
]# mysqldumpslow host50-10-slow.log #//统计数据库里面的命令
]# tailf  /var/lib/mysql/host50-10-slow.log  #//动态查看数据库里面的命令




