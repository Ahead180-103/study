mysql多实例
多实例是指在一台物理主机上运行多个数据库服务
为什么要使用多实例
– 节约运维成本
– 提高硬件利用率
show processlist;  #//查看客户端地址
安装支持多实例服务的软件包
[root@host50 ~]# tar -zxvf mysql-5.7.20-linux-glibc2.12-x86_64.tar.gz
[root@host50 ~]# mv mysql-5.7.20-linux-glibc2.12-x86_64 /usr/local/mysql
[root@host50 ~]# tail -1 /etc/profile
export PATH=/usr/local/mysql/bin:$PATH
[root@host50 ~]# source /etc/profile

置文件参数说明
主配置文件 /etc/my.cnf
[root@host50 ~]#mv /etc/my.cnf  /etc/my.cnf.bak
[root@host50 ~]# cat  /etc/my.cnf

[mysqld_multi] #// 启用多实例
mysqld = /usr/local/mysql/bin/mysqld_safe #// 指定进程文件的路径
mysqladmin = /usr/local/mysql/bin/mysqladmin #// 指定管理命令路径
user = root 	#// 指定调用进程的用户

[mysql1] 	#// 实例进程名称
port= 3307    #// 端口号
datadir = /data3307   #// 数据库目录 ,要手动创建
socket=/data3307/mysql.sock #// 指定 sock 文件的路径和名称
pid-file = /data3307/mysqld.pid #// 进程 pid 号文件位置
log-error = /data3307/mysqld.err #// 错误日志位置

[mysql1] 	#// 实例进程名称
port= 3308    #// 端口号
datadir = /data3308   #// 数据库目录 ,要手动创建
socket=/data3308/mysql.sock #// 指定 sock 文件的路径和名称
pid-file = /data3308/mysqld.pid #// 进程 pid 号文件位置
log-error = /data3308/mysqld.err #// 错误日志位置
:x

#// 初始化授权库
#//格式：mysqld --user=mysql --basedir= 软件安装目录 --datadir= 数据库目录 --initialize // 初始化授权库
#
[root@host50 mysql]# mysqld --user=mysql  --basedir=/usr/local/mysql  --datadir=/dir3307  --initialize
2018-06-27T02:31:52.018530Z 1 [Note] A temporary password is generated for root@localhost: NM.EaaXlw00r


[root@host50 mysql]# mysqld --user=mysql  --basedir=/usr/local/mysql  --datadir=/dir3308  --initialize
2018-06-27T02:34:28.738832Z 1 [Note] A temporary password is generated for root@localhost: sf(/Tvvzo3hB 

#//启动实例进程 #/ 初始化授权库
#//格式：mysqld_multi start 实例编号
[root@host50 mysql]# mysqld_multi start 1 
[root@host50 mysql]# netstat  -utnlp | grep :3307

[root@host50 mysql]# mysqld_multi start 2
[root@host50 mysql]# netstat  -utnlp | grep :3308

#//连接数据库服务，修改本机登陆密码
#//格式：mysql -uroot –p 初始密码 -S sock文件
[root@host50 mysql]# mysql -uroot -p"NM.EaaXlw00r" -S /dir3307/mysqld3307.sock
mysql> alter user root@"localhost" identified by "123456";


[root@host50 mysql]# mysql -uroot -p"sf(/Tvvzo3hB" -S /dir3308/mysqld3308.sock
mysql> alter user root@"localhost" identified by "123456";

停止数据库服务：
mysqld_multi --user=root --password=密码 stop 实例编号 // 停止实例进程

[root@host50 mysql]# mysqld_multi  --user=root  --password=123456 stop 1
[root@host50 mysql]# netstat  -utnlp | grep :3307
[root@host50 mysql]# mysqld_multi  --user=root  --password=123456 stop 2
[root@host50 mysql]# netstat  -utnlp | grep :3308


