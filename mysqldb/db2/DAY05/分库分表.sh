#分库/分表:通过某种特定条件,将存放在一个数据库 ( 主机 ) 中的数据,分散存放到多个数据库 ( 主机 ) 中。
#1、已达到分散单台设备负载的效果,即分库分表
#2、 数据的切分根据其切分规则的类型,分为 2 种切分模式
#3、垂直分割 ( 纵向 ) 和 水平分割 ( 横向 )

#垂直（纵向）切分
	#1、把单一的表,拆分成多个表,并分散到不同的数据库( 主机 ) 上。
	#2、 一个数据库由多个表构成,每个表对应不同的业务,可以按照业务对表进行分类,将其分布到不同的数据库 ( 主机 ) 上,实现专库专用,让不同的库 ( 主机 ) 分担不同的业务。

#横向切分水平分割
	#1、按照表中某个字段的某种规则,把向表中写入的记录分散到多个库 ( 主机 ) 中。
	#2、简单来说,就是按照数据行切分,将表中的某些行存储到指定的数据库 ( 主机 ) 中。


#数据库系统的mycat包
#配置数据分片数据56步骤：
##1、安装 JDK
#	[ root@host56 ~]# rpm -qa | grep -i jdk # 安装系统自带的即可
##2、安装 mycat 服务软件包
	[ root@host56 ~]# tar -zxf Mycat-server-1.4-beta-20150604171601-linux.tar.gz # 免安装,解压后即可使用
	[ root@host56 ~]# mv mycat/ /usr/local/
	[root@host56 ~]# ls /usr/local/mycat/
#	#重要配置文件说明
#	– server.xml 设置连接 mycat 服务的账号 、密码等
#	– schema.xml 配置 mycat 使用的真实数据库和表
#	– rule.xml   定义 mycat 分片规则
#
#2.1 定义连接mycat服务的用户和密码及虚拟的数据库名称:server.xml
#test test TESTDB  读写权限
#user user TESTDB  只读权限
#2.2 对那些表做数据分片使用的分片规则  schema.xml
#逻辑表名  使用的分片规则	存储在那个数据库服务器  dn1  dn2
#
#指定dn1  存储数据库名：db1
#指定dn2  存储数据库名：db2
#
#指定dn2  存储数据库服务器ip地址
#指定dn2  存储数据库服务器ip地址
#
#根据配置在指定的数据服务器上创建库和连接用户
#
#3 启动服务
[root@host56 conf]# /usr/local/mycat/bin/mycat  start 
#
#4 查看服务信息
[root@host56 conf]# netstat  -nutlp  |  grep :8066
#
#5 客户端配置
[root@root9pc01 ~]# mysql -h192.168.4.56   -P8066 -utest -ptest 
MySQL [TESTDB]> use TESTDB;
MySQL [TESTDB]> show tabels;
MySQL [TESTDB]> desc employee;
MySQL [TESTDB]> create table employee ( id int not null primary key, name varchar(100),age int(2),sharding_id int not null);
desc employee;
insert into employee(id,name,age,sharding_id) values(1,"bob",22,10000),(2,"lisi",22,10010);
#存储到那个数据库服务器
#
#
#修改配置文件 ( 续 2)
• 修改配置文件 /usr/local/mycat/conf/server.xml
	<user name="test"> # 连接 mycat 服务时使用的用户名：test
		<property name="password">test</property> # 使用test 用户连接 mycat 用户时使用的密码
		<property name="schemas">TESTDB</property> # 连接上 mycat 服务后,可以看到的库名多个时,使用逗号分隔 (是逻辑上的库名TESTDB)
	</user>
		<user name="user">
		<property name="password">user</property>
		<property name="schemas">TESTDB</property>
		<property name="readOnly">true</property> # 定义只读权限,使用定义的 user 用户连接 mycat 服务后只有读记录的权限
	</user>
• 修改配置文件 /usr/local/mycat/conf/schema.xml
– 定义分片信息
          <schema name="TESTDB" checkSQLschema="false" sqlMaxLimit="100">  #//逻辑名TESTDB要与 server.xml定义的一样
                <table name="travelrecord" dataNode="dn1,dn2" rule="auto-sharding-long" />	#//定义分片表travelrecord
                <table name="company" primaryKey="ID" type="global" dataNode="dn1,dn2" />	#//定义分片表company
                <table name="goods" primaryKey="ID" type="global" dataNode="dn1,dn2" />	#//定义分片表goods
                <table name="hotnews" primaryKey="ID" dataNode="dn1,dn2" rule="mod-long" />	#//定义分片表hotnews
                <table name="employee" primaryKey="ID" dataNode="dn1,dn2" rule="sharding-by-intfile" />	#//定义分片表employee
 	 
	  <dataNode name="dn1" dataHost="host51" database="db1" />
        <dataNode name="dn2" dataHost="host52" database="db2" />

#指定c1名称的对应的ip地址
       <dataHost name="host51" maxCon="1000" minCon="10" balance="0"
                writeType="0" dbType="mysql" dbDriver="native" switchType="1"  slaveThreshold="100">
                <heartbeat>select user()</heartbeat>
                <writeHost host="hostM1" url="192.168.4.51:3306" user="root"
                        password="123456">
                </writeHost>
        </dataHost>
#指定c2名称的对应的ip地址
       <dataHost name="host2" maxCon="1000" minCon="10" balance="0"
                writeType="0" dbType="mysql" dbDriver="native" switchType="1"  slaveThreshold="100">
                <heartbeat>select user()</heartbeat>
                <writeHost host="hostM1" url="192.168.4.52:3306" user="root"
                        password="123456">
                </writeHost>
        </dataHost>







