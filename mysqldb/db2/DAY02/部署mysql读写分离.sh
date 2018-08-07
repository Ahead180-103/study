部署mysql主从同步
1、要求：把20配置成为10的从库
配置主库10
启用binlog日志
vim /etc/my.cnf
[mysqld]
server_id=51
log-bin=master51
binlog-format="mixed"
:wq
systemctl restart  mysqld     
ls  /var/lib/mysql/master51.*
用户授权
 grant all on db12.* to yaya@"%" identified by "123456";
查看日志信息
mysql> show master status;

配从库20
验证授权
指定server_id
指定主库信息
查看从库状态


客户端验证主库同步配置
在主库添加访问数据的连接用户设置密码
create database db12;
grant all on db12.* to yaya@"%" identified by "123456";
客户端连接主库 执行sql命令
]# mysql -h192.168.4.10 -uyaya -p123456
mysql> select * from db12.a;

mysql中间件：mysql-proxy  mycat maxscale

在主机100上部署代理服务，实现数据读写分离
cp /etc/maxscale.cnf  /etc/maxscale.cnf.bak
vim  /etc/maxscale.cnf  
[maxscale]
threads=auto

[server1]    #// 定义数据库服务器主机名
type=server
address=192.168.4.10   #//master 主机 ip 地址
port=3306
protocol=MySQLBackend

[server2]       #// 定义数据库服务器主机名
type=server
address=192.168.4.20    #//master 主机 ip 地址
port=3306
protocol=MySQLBackend

[MySQL Monitor]  #// 定义要监视的数据库服务器
type=monitor
module=mysqlmon
servers=server1, server2    #// 定义的主、从数据库服务器主机名
user=scalemon #// 用户名,可以任意取,取名时最好有标示性
passwd=mypwd  	#// 密码
monitor_interval=10000

#[Read-Only Service]
#type=service
#router=readconnroute
#servers=server1
#user=myuser
#passwd=mypwd
#router_options=slave


[Read-Write Service] #// 定义实现读写分离的数据库服务器
type=service
router=readwritesplit   #功能模块readwritesplit
servers=server1,server2 #// 定义的主、从数据库服务器主机名
user=maxscale #// 用户名
passwd=111111 #// 密码
max_slave_connections=100%


#[Read-Only Listener]
#type=listener
#service=Read-Only Service
#protocol=MySQLClient
#port=4008

[Read-Write Listener]
type=listener
service=Read-Write Service   #//时上面[Read-Write Service] #// 定义实现读写分离的数据库服务器
protocol=MySQLClient
port=4006			#//读写监听端口

[MaxAdmin Listener]
type=listener
service=MaxAdmin Service
protocol=maxscaled
socket=default
port=4099      #//添加管理监听端口

在主、从数据库服务器创建授权用户(先搭建主从服务，这样授权可以用户同步过去)
mysql> grant replication slave, replication client on *.* to scalemon@'%' identified by “123456”; #// 创建监控用户
mysql> grant select on mysql.* to maxscale@'%' identified by “123456”;	 #// 创建路由用户
mysql> grant all on *.* to student@'%' identified by “123456”;	 	#// 创建访问数据用户
mysql> select user from mysql.user where user in ("scalemon","maxscale");

启动 maxscale服务
maxscale -f /etc/maxscale.cnf   #//启动 maxscale
maxscale --config=/etc/maxscale.cnf #//另一种启动 maxscale服务方式
查看状态
netstat -utnalp | grep maxscale

测试主机：
1、在主机100上连接管理服务查看监控信息
]# maxadmin -uadmin -pmariadb -P4099		#//本地登陆管理服务
MaxScale> list servers	#//查看管理服务
2、在客户端连接100，访问数据时能否实现数据读写分离
ping -c 2 192.168.4.100
which mysql  #//查看是否有该命令
]# mysql -h192.168.4.100 -P4006  -uyaya -p123456
mysql> select @@hostname;


select user,host from mysql.user;
change master to master_host="192.168.4.51",master_user="repluser",master_password="123456",master_log_file="master51.000001",master_log_pos=441;
start slave;
show slave status\G;
set global relay_log_purge=off;

