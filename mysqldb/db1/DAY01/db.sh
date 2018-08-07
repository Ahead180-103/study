讲师：庞丽静
讲师邮箱：panglj@tedu.cn
linux系统管理
第三阶段15天  数据库管理    工作岗位  DBA   
DBA基础  5天
DBA进阶  5天
NoSQL   5天

DBAday01
一搭建数据服务器
二数据库服务的基本使用
三Mysql数据类型

一搭建数据服务器

服务器：考虑CPU  内存  存储
操作系统的版本： windows    linux    unix
                         rhel7
装包：  源码 or rpm 包的来源  软件的版本
                      官网
#################################################
RDBMS关系行数据库：Oracle  BD2  Mysql   MariaDB  SQL Server
NoSQL非关系行数据库：Redis Mongodb
主流数据库库服务软件：Oracle  BD2  Mysql   MariaDB
			SQL Server
开源版本：
商业软件:
跨平台

修改配置文件：
启动服务：

三、数据类型
数值类型 :  整数型 和浮点型
create table db1.t2(
level 
字符类型
日期时间  年  日期  时间      日期时间
枚举类型  enum   set

create table t6(
name char(15),						//姓名，字符长度为15个字符
age tinyint unsigned,					//年龄，字符长度为1个字节
pay float(7,2),
sex enum("boy","gril","no"),				//枚举单选
likes set("women","money","game","eat")		//枚举多选
);
#插入数据
insert into t6 values("bob3",25,25000,"no","eat,game"),("bob4",22,21000,1,"eat,money");

练习：
create table dogperson(name char (15),sex enum("boy","gril")heigth float(3,2),weight(kg) float(3,1),age tinyint unsigned,address varchar(50),yyear year,email varchar(50),phone char(11),);

DBA1 day02
约束条件
修改表结构
mysql键值

约束条件
null 允许为空,默认设置
not null 不允许为空
Key索引类型
default 设置默认值,缺省为 NULL

mysql键值
index :普通索引  *
unique :唯一索引

fulltext :全文索引
primary key :主键  *
foreign key :外键  *

主键
创建复合主键
create table t19(
cip char(15),
serport smallint(2),
status  enum("yes","no"),
primary key (cip,serport) 7
);
插入数据
insert into t19 values ("1.1.1.1",22,1);
insert into t19 values ("1.1.1.1",21,2);
insert into t19 values ("1.1.1.2",21,2);
select * from t19;


删除主键盘
alter  table t19 drop primary key;
desc t19;
添加主键
alter  table t19 add primary key(cip,serport);
desc t19;

AUTO_INCREMENT  字段值自增长  ++
  
create table t20(stu_id int(2)  primary key auto_increment,name char(10),age tinyint(2));
select * from t20;
insert into t20(name,age) values("jeryy",29);
insert into t20(name,age) values("jery",28);
insert into t20 values(5,"jey",23);
给原有表添加id自增长
alter table stuinfo add id int(2) primary key auto_increment first;
外键
ygb
yg_id	    naem   	bumen
1		bob	tea	
2		bob	tea	
3		
create table gzb (
字段列表，
foreign key 



ygb  员工表
员工编号
姓名
部门
ygb_id

create table ygb(yg_id int(2) primary key auto_increment,name char(15),bumen char(20))engine=innodb;
insert into ygb(name,bumen)values ("bob","tea"),("jack","tea");
insert into ygb(name,bumen)values ("tom","shichang");
select * from ygb;


工资表
create table gzb(     //创建
gz_id int(2),name char(15),pay float (7,2),bumen char(20),foreign key (gz_id)references ygb(yg_id) on update cascade on delete cascade )engine=innodb;



insert into gzb values(1,"bob",20000,"tea");



修改员工字段
insert into gzb values();
修改员工编号id
update ygb set yg_id=8 where name="bob";
删除员工
delete from ygb where yg_id=2;
删除员工所有信息
delete from ygb;
查看主键信息
show index from gzb\G;
查看建表指令信息及键名
show create table gzb;
删除外键
alter table gzb drop foreign key gzb_ibfk_1;
drop table ygb ;





