#mysql存储过程
#创建存储过程
#################################################################
##语法格式
	#delimiter //
	#create procedure  名称()
	#begin
	#功能代码
	#.....
	#.....
	#end
	#//
	#结束存储过程
	#delimiter ;
##delimiter 关键字声明当前段分隔符  MySQL 默认以" ; " 为分隔符,没有声明分割符,编译器会把存储过程当成 SQL语句进行处理,则存储过程的编译过程会报错。
############################################################################################################
delimiter //
create procedure say()
begin
select * from db9.user;
select *from mysql.user where user="root";
end
//
delimiter ;

delimiter //
create procedure say1() begin select * from db9.user2; select *from mysql.user where user="root"; end //
delimiter ;
#调用存储过程
#格式：Call 存储过程名 ()     #//存储过程没有参数时, () 可以省略有参数时,在调用存储过程时,必须传参。
call say();			#//调用say函数
call say;			#//调用say函数
#删除存储过程
#drop procedure 存储过程名;
#查看存储过程

show procedure status\G;   #//查看数据库的所有存储过程
select db,name,type from mysql.proc;

select db,name,type from mysql.proc where name=" 存储过程名 ";
	#编写功能体代码时，可以使用
	#变量  条件判断   流程控制 （if 循环）
	#算术计算  sql命令
 
案例:创建存储过程满足以下要求:
存储过程名称为 p1
功能显示 user 表中 shell 是 /bin/bash 的用户个数
调用存储过程 p1
delimiter //
create procedure p1()
begin
select count(name) from db9.user where shell="/bin/bash";
end
//
Query OK, 0 rows affected (0.00 sec)

delimiter ;
mysql> call p1;          
+-------------+
| count(name) |
+-------------+
|           2 |
+-------------+


案例 4 :练习存储过程参数的使用
满足以下要求:
– 创建名为 p2 的存储过程
– 可以接收用户输入 shell 的名字
– 统计 user 表中用户输入 shell 名字的个数

mysql> delimiter //
mysql> create procedure p2()
mysql> begin
mysql> declare x int default 77;
mysql> declare y char(10);
mysql> set y="yaya";
mysql> select x;
mysql> select y;
mysql> end
mysql> //
mysql> delimiter ;
mysql> call p2();
 
mysql> select @x;
 
mysql> select @y;

mysql> show global variables\G;                 #// 查看全局变量
mysql> set session sort_buffer_size=40000;      #// 设置会话变量
  
  
mysql> show session variables like "sort_buffer_size";  #// 查看会话变量

mysql> delimiter // 
create procedure p3() 
begin 
declare x int default 77;
select x;
select max(uid) into @x from user2;
end
//
delimiter ;
#
#
mysql> delimiter //
	-> create procedure p4() begin  
	-> declare x int ;
	-> declare y int ;
	-> declare z int ;
	-> select count(shell) into x from db9.user where shell="/bin/bash";
	-> select count(shell) into y from db9.user where shell="/sbin/nologin";
	-> set z=x+y
	-> select z; 
	-> end
 	-> //
mysql> delimiter ;

#存储过程进阶:参数类型
#MySQL 存储过程,共有三种参数类型 IN,OUT,INOUT
#格式：Create procedure 名称 (类型 参数名 数据类型 ,类型 参数名 数据类型)
#	关键字     名称              描述
#	in       输入参数          作用是给存储过程传值,必须在调用存储过程时赋值,在存储过程中该参数的值不允许修改;默认类型是 in
#	out      输出参数          该值可在存储过程内部被改变,并可返回。
#      inout    输入/ 输出参数    调用时指定,并且可被改变和返回
#注意:此三中类型的变量在存储过程中调用时不需要加 @ 符号 !!!

#	in       输入参数          作用是给存储过程传值,必须在调用存储过程时赋值,在存储过程中该参数的值不允许修改;默认类型是 in
mysql> delimiter //
mysql> create procedure p5(in username char(10)) # 定义 in 类型的参数变量 username
	-> begin
	-> select username;
	-> select * from user where name=username;
	-> end
	-> //
Query OK, 0 rows affected (0.00 sec)
mysql> delimiter ;


mysql> call p5("root"); # 调用存储过程时给值。
+----------+
| username |
+----------+
| root  |
+----------+
1 row in set (0.00 sec)
+----+------+------+----------+------+------+---------+---------+---------+
| id | name | sex | password | pay | gid | comment | homedir | shell |
+----+------+------+----------+------+------+---------+---------+---------+
| 01 | root | boy | x| 0 | 0 | root| /root | /bin/bash |
+----+------+------+----------+------+------+---------+---------+---------+
1 row in set (0.00 sec)


mysql> delimiter //
mysql> create procedure p6( out num int(2)) # 定义 out 类型的参数变量 num
	begin
	select num;
	set num=7;
	select num;
	select count(name) into num from db9.user where shell!="/bin/bsah";
	select num;
	 end
mysql> //
Query OK, 0 rows affected (0.00 sec)
mysql> delimiter ;

mysql> call p6();  #//报错，括号内部不允许为空值
mysql> call p6(7); #//报错，括号内的参数不允许为数值，必须为变量
mysql> set @x=1;	#//定义变量x=1
mysql> call p6(@x);	#//正确


	delimiter //
	create procedure p7( inout num int(2)) # 定义 inout 类型的参数变量 num
	begin
	select num;
	set num=7;
	select num;
	select count(name) into num from db9.user where shell!="/bin/bsah";
	select num;
	 end
	//
Query OK, 0 rows affected (0.00 sec)
	delimiter ;
mysql> set @x=9;
mysql> call p7(@x);
	+------+
	| num  |
	+------+
	|    9 |
	+------+
	1 row in set (0.00 sec)

	+------+
	| num  |
	+------+
	|    7 |
	+------+
	1 row in set (0.00 sec)

	+------+
	| num  |
	+------+
	|   41 |
	+------+
	1 row in set (0.00 sec)

Query OK, 0 rows affected (0.00 sec)

######### 顺序结构 if 判断 #################################

#格式1： 当“条件成立”时执行命令序列， 否则,不执行任何操作
	if 条件测试 then
	代码......
	.....
	end if ;
#例题：

#格式：当“条件成立”时执行代码 1, 否则,执行代码 2
	if 条件测试 then
	代码 1 ......
	.....
	else
	代码 2......
	.....
	end if;

#例题1：顺序结构
mysql> drop procedure if exists p8;
mysql> delimiter //
mysql> create procedure p8(in num int(1) )
	begin
	if num <= 10 then
	select * from db9.user where id <=num;
	end if;
	end
	//
mysql> delimiter ;
mysql> call p8(1); # 条件判断成立
+-------+---------+---------+----------------+---------+---------+------------+------------+------------------------+
| id | name | sex | password | pay | gid | comment | homedir | shell	 |
+-------+---------+---------+----------------+---------+---------+------------+------------+------------------------+
| 01 | root | boy | x	| 0 	|0	| root	| /root | /bin/bash	 |
+-------+---------+---------+----------------+---------+---------+------------+------------+-------------------------+

#例题2：顺序结构
mysql> drop procedure if exists p9;
mysql> delimiter //
mysql> create procedure p9(in num int(2) )
	begin
	if num is null then 
			select * from db9.user where id =2;
	else
		select * from db9.user where id <=num;
	end if;
	end
	//
mysql> delimiter ;
mysql> call p9();  #//报错
mysql> call p9(1); # 条件判断成立输出
+-------+---------+---------+----------------+---------+---------+------------+------------+------------------------+
| id | name | sex | password | pay | gid | comment | homedir | shell	 |
+-------+---------+---------+----------------+---------+---------+------------+------------+------------------------+
| 01 | root | boy | x	| 0 	|0	| root	| /root | /bin/bash	 |
+-------+---------+---------+----------------+---------+---------+------------+------------+-------------------------+

#循环结构
#1、条件式循环：反复测试条件, 只要成立就执行命令序列
#格式：	while 条件判断 do
#		循环体
#		.......
#		end while ;

#2、条件式循环，无循环条件
#格式：	loop
#		循环体
#		......
#		end loop ;

#3、条件式循环，until 条件判断,成立时结束循化
#格式：	repeat
#	循环体
#	until 条件判断  #//条件判断后不要加分号
#	end repeat ;

######### 死循环结构 (while 1) #################################
mysql> drop procedure if exists p10;
	delimiter //
	create procedure p10()
	begin
		declare i int(2);
		set i=1;
	while i <=5 do 
			set i=i+1;
mysql> 	end while;
mysql> 	select i;
mysql> 	end
 	//
mysql> delimiter ;
mysql>  call p10();
+------+
| i    |
+------+
|    6 |
+------+
1 row in set (0.00 sec)
Query OK, 0 rows affected (0.00 sec)

mysql> drop procedure if exists p11;
mysql> delimiter //
mysql> create procedure p11()
   ->  begin
   ->  declare i int(2);		#//声明局部变量i
   ->  declare j int(2);		#//声明局部变量j
   ->  select count(id) into i from db9.user;		#//查看db9.user中的id值赋值给i
   ->  set j=1;					#//
   ->  while j <=i do 
   ->  if j % 2 = 0 then 
   ->  select * from  db9.user where id = j;
   ->  end if ;
   ->  set j=j+1;
   ->  end while;
   ->  select i;
   ->  end
    ->  //
mysql> delimiter ;
mysql>  call p11();
######### 无条件循环结构 (loop 2) #################################
mysql> drop procedure if exists p12;
mysql> delimiter //
   ->  create procedure p12()
   ->  begin
   ->      declare j int (2);
   ->      set j = 1 ;
   ->      loop
   ->          select j;
   ->          set j=j+1;
   ->      end loop;
   ->  end 
   -> // 
mysql> delimiter ;


######### 条件成立循环退出 (repeat ） #################################
mysql> drop procedure if exists p13;
mysql> delimiter //
mysql> reate procedure p13()
   -> begin
   ->     declare j int (2);
   ->     set j = 1 ;
   ->     repeat
   ->         select j;
   ->         set j=j+1;
   ->         until j=6
   ->      end repeat;
   -> select j;
   -> end 
    -> // 
mysql> delimiter ;
mysql> call p13;



mysql> drop procedure if exists p14;
mysql> delimiter //
mysql> reate procedure p14()
   -> begin
   ->     declare j int (2);
   ->     set j = 1 ;
   ->     repeat
   ->         select j;
   ->         set j=j+1;
   ->         until j=1     #//进入死循环
   ->      end repeat;
   -> end 
    -> // 
mysql> delimiter ;
mysql> call p14;


# 流程控制
#顺序结构  if
#循环结构  while loop   repeat
#控制循环结构的执行
#
#循环结构控制语句 , 控制循环结构的执行。
#LEAVE 标签名 // 结束循环的执行，跳出循环
#ITERATE 标签名 / 结束当前的循环,执行下一次循环
#leave 控制loop  ，iterte控制while，repeat
################################################################
delimiter //
create procedure p15()
begin
declare i int(1);
set i = 1 ;
loab1:while i <=10 do 
  set i=i+1 ;
    if i = 7 then 
        iterate loab1;
      end if ;  
select i;
 end while;
end
//
delimiter ;
call p15;


delimiter //
create procedure p16()
begin
declare i int(1);
set i = 1 ;
loab1:loop  
   select i;
   set i=i+1 ;
    leave loab1;
end loop;
end
//
delimiter ;
call p16;
