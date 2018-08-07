部署mysql高可用集群（MHA软件+主从同步）

集群时使用多台服务器提供的相同服务51-55
高可用集群 主备模式： 当主角色的主机宕机后，备用主机自动接替主角色的主机提供服务服务给客户端。

cilent mysql -h192.168.4.52  -uadmin -p123456

MHA

host56 监控服务

vip地址：192.168.4.100

主		备用主		备用主		
mysql51	mysql2	mysql53	mysql54	mysql55
		slave		slave		slave		slave

第一步：准备MHA运行环境
	一主多从
	安装依赖的软件包
	ssh root用户无密码登陆

第二步：配置MHA

2.1配置数据主机（一主到从 安装依赖的软件包 彼此之间可以ssh root 无密码登陆） 192.168.4.100

 2.1.1 一主多从

 2.1.2 安装依赖的perl软件包

 2.1.3安装软件mha-node

[root@host51~]# cd  数据库软件包/mha-soft-student/ 
[root@host51 mha-soft-student]# yum -y install perl-DBD-mysql
[root@host51 mha-soft-student]# rpm -ivh mha4mysql-node-0.56-0.el6.noarch.rpm

 2.1.4 配此之间可以ssh root用户无密码登陆

 2.1.5 授权监控用户
 
mysql> grant all on *.* to root@"%" identified by "123456";
mysql> grant replication slave on *.* to repluser@"%" identified by "123456";
 2.1.6 所有数据库服务器启不删除本机的中继日志文件
mysql> set global relay_log_purge=off;// 不自动删除本机的中继日志文件
2.2 配置管理主机 192.168.4.56
 2.2.1 安装依赖的perl软件包

 2.2.2 安装软件mha-node

[root@host56~]# cd  /root/桌面/数据库软件包/mha-soft-student/ 
[root@host56 mha-soft-student]# yum -y install perl-DBD-mysql
[root@host56 mha-soft-student]# rpm -ivh mha4mysql-node-0.56-0.el6.noarch.rpm	
	
	源码安装mha4mysql-manager

[root@host56 mha-soft-student]# yum -y install perl-ExtUtils-* perl-CPAN-*
[root@host56 mha-soft-student]#tar -zxf mha4mysql-manager-0.56.tar.gz
[root@host56 mha-soft-student]#cd mha4mysql-manager-0.56
[root@host56 mha4mysql-manager-0.56]# perl Makefile.pl
[root@host56 mha4mysql-manager-0.56]# make
[root@host56 mha4mysql-manager-0.56]# make install
 
2.2.3 指定命令所在的路径

 [root@host56 ~]# cd 	/root/桌面/数据库软件包/mha-soft-student/mha4mysql-manager-0.56
 [root@host56 mha4mysql-manager-0.56]#  mkdir /root/bin
 [root@host56 mha4mysql-manager-0.56]# cp bin/* /root/bin
 [root@host56 mha4mysql-manager-0.56]# ls /root/bin
 2.2.4 修改配置文件
 [root@host56 ~]# mkdir /etc/mha_manager/
 [root@host56 ~]# cd /root/桌面/数据库软件包/mha-soft-student/mha4mysql-manager-0.56/samples/conf
 [root@host56 mha4mysql-manager-0.56]# cp app1.cnf   /etc/mha_manager/app1.cnf
 [root@host56 mha4mysql-manager-0.56]# cd ~
 [root@host56 ~]# vim /etc/mha_mannger/app1.cnf 
	  [server default]
	manager_workdir=/etc/mha_manager
	manager_log=/etc/mha_manager/manager.log
	master_ip_failover_script=/etc/mha_manager/master_ip_failover

	ssh_user=root
	ssh_port=22

	repl_user=repluser
	repl_password=123456

	user=root
	password=123456

	[server1]
	hostname=192.168.4.51
	candidate_master=1

	[server2]
	hostname=192.168.4.52
	candidate_master=1

	[server3]
	hostname=192.168.4.53
	candidate_master=1

	[server4]
	hostname=192.168.4.54
	no_master=1

	[server5]
	hostname=192.168.4.55
	no_master=1
	:wq
[root@host56 ~]# cd mha4mysql-manager-0.56/samples/scripts    #//
[root@host56 ~]# cp master_ip_failover  /etc/mha_manager/	#//master_ip_failover 文件需要perl编译

[root@host56 ~]# rm  -rf /etc/mha_manager/master_ip_failover
[root@host56 ~]# cp /root/桌面/数据库软件包/mha-soft-studentmaster_ip_failover /etc/mha_manager/  	#//master_ip_failover正常文件需要perl编译，上课前已经被老师已经编译ok，只需进去修改vip地址
[root@host56 ~]# chmod +x /etc/mha_manager/master_ip_failover
[root@host56 ~]# vim /etc/mha_manager/master_ip_failover
	 my $vip = '192.168.4.100/24';  # Virtual IP 
	 my $key = "1";
	 my $ssh_start_vip = "/sbin/ifconfig eth0:$key $vip";
	 my $ssh_stop_vip = "/sbin/ifconfig eth0:$key down";

测试配置文件

[root@host56 ~]# vim  /etc/mha_manager/app1.cnf 
[server default]
 #master_ip_failover_script=/etc/mha_manager/master_ip_failover
[root@host56 ~]# masterha_check_ssh --conf=/etc/mha_manager/app1.cnf    #//测试ssh root用户22号是否可通过

[root@host56 ~]# masterha_check_repl --conf=/etc/mha_manager/app1.cnf    #//测试 数据库sql repl用户是否可以连接
   MySQL Replication Health is OK.

3、启动服务：
3.1 把vip 地址手动绑定在主库上

[root@host51 ~]# ifconfig eth0:1 192.168.4.100/24
[root@host51 ~]# ifconfig eth0:1 
3.2 启动服务
[root@host56 ~]# vim  /etc/mha_manager/app1.cnf 
	[server default]
	 master_ip_failover_script=/etc/mha_manager/master_ip_failover
[root@host56 ~]# masterha_manager    --conf=/etc/mha_manager/app1.cnf --remove_dead_master_conf  --ignore_last_failover  #//说明remove_dead_master_conf是说主库down后删除app1.cnf中的配置文件对应的信息  ，ignore_last_failover是指在8个小时内不能down多次
[root@host56 ~]#masterha_check_status --conf=/etc/mha_manager/app1.cnf   #//查看mha运行状态
4、测试高可用集群配置
在数据库服务上添加访问数据连接用户 webuser  123456
[root@root9pc01 ~]# mysql -h192.68.4.51 -uroot -p123456
MySQL > create database db13;
mysql> grant all on  db13.* to webuser@"%" identified by "123456"；

4.1 客户端连接VIP地址访问数据库
]# mysql -h192.168.4.100 -uwebuser -p123456


4.2 测试高用集群

把主机51上的数据库服务停止 
]# systemctl stop mysqld

把宕机的数据库服务器51 在添加到当前集群里
]# mysql -h192.68.4.51 -uroot -p123456
mysql> change master to master_host="192.168.4.52", master_user="repluser",master_password="123456",master_log_file="master52.000001",master_log_pos=154;

mysql> start slave;

56：
]# vim /etc/mha_manager/app1.cnf
[server1]
candidate_master=1
hostname=192.168.4.51

:wq

]# masterha_check_repl --conf=/etc/mha_manager/app1.cnf
MySQL Replication Health is OK.


]#masterha_manager --conf=/etc/mha_manager/app1.cnf --remove_dead_master_conf  --

ignore_last_failover

