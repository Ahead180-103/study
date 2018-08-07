视图
准备环境：host55 mysql主机
[root@host55 ~]# mysql -uroot -p123456
mysql> create database db9;
mysql> use db9
mysql> create table user(name char(20)  ,password char(1),uid int (2),gid int (2),comment char(150), homedir char(150),shell char(30));
mysql> system ls /var/lib/mysql-files	#//mysql导入文件爱你默认在/var/lib/mysql-files
mysql> system cp /etc/passwd  /var/lib/mysql-files
mysql> system ls /var/lib/mysql-files/passwd
#导入数据到对应表中
mysql> load data infile "/var/lib/mysql-files/passwd" into table  user fields terminated by  ":" lines terminated by "\n";
#插入字段并设置为主键
mysql> alter table user add id int(2) primary key auto_increment first;

#创建view视图表（虚拟表）
mysql> create view t1 as select name,shell from user where uid<=20;

#查看（那些表是视图表 那些是物理表）
mysql> show table status where comment="view"\G;

#查看视图的数据是那个基表里的
mysql> show create view t1;

mysql> create view t4(user,stu_uid,stu_gid) as select name,uid,gid from user limit 3;

#查看（哪些表是视图表 哪些是物理表）

mysql> show table status where comment="view"\G;

#查看视图的数据是哪个基表里的
mysql> show   create  view  t1;

#使用视图  对视图表里的数据做 select  insert  update delete 

#删除视图
#格式：drop  view  视图名；
 
#创建视图时必须给视图中的字段定义别名的情况

mysql> create table user2 select name,uid ,shell from user limit 5;
mysql> create table info select name,uid ,shell from user limit 10;

#创建视图时必须给视图中的字段定义别名的情况
mysql> create view v2 as  select  a.name as aname , b.name as bname , a.uid as auid , b.uid as  buid from user2 a left join info b on a.uid=b.uid;
mysql> create  view  v22 as select  user2.name as uname,info.name as iname from user2 left join info on user2.uid=info.uid;
#as后一般前面加表名和自字段名，后跟查询来想要给的字段别名
mysql> select  * from v22;
#
#WITH 方式 CHECK OPTION  作用是定义对视图表里的数据做操作时的限制方式。
#方式	local    满足视图本身的限制即可。
#	cascaded  同时满足基表的限制（默认值）。
mysql> create table user2 select name,uid,shell from user;   #//创建基表

 create  view v1 as select * from user2 where uid<=30;		#创建v2视图表
select * from v1;

create view v2 as  select * from v1 where uid>=20  with check option;    #//with 方式 check option中方式不指定默认是cascaded
select * from v1;

update v2 set uid=19 where name="mysql";   #//创建失败，不满足v2表的创建条件uid>=20

update v2 set uid=39 where name="mysql";   #//创建失败，不满足v2表的创建条件select * from v1（create  view v1 as select * from user2 where uid<=30;）

select * from user2  where name="mysql";
select * from v1  where name="mysql";
select * from v2  where name="mysql";

update v2 set uid=29 where name="mysql";   #//创建成功

select * from user2  where name="mysql";
select * from v1  where name="mysql";
select * from v2  where name="mysql";

create view v3 as select * from v1 where uid>=20  with local check option; #//指定了 方式为local仅检查当前的限制，当前自己的条件为真创建成功，
show create view v3\G;	#//查看创建条件
select * from v3;


update v3 set uid=39 where name="mysql";   #//创建成功

select * from user2  where name="mysql";    #//可以查看到修改到的数据
select * from v1  where name="mysql";       #//可以查看不到修改到的数据，数据被删除
select * from v2  where name="mysql";       #//可以查看不到修改到的数据，数据被删除
select * from v3  where name="mysql";       #//可以查看不到修改到的数据，数据被删除


