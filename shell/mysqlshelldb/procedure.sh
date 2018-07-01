delimiter //
create procedure say1()
begin
select  * from db9.user;
select  * from mysql.user where user="root";
end
//
delimiter ;

call  say1();
call  say1;

11:00
+++++++++++++++++++++++++++++++++++
delimiter //
create procedure p1()
begin
  select count(name) from db9.user where shell="/bin/bash";
end
//
delimiter ;
call  p1();

+++++++++++++++++++++++++++++++++
delimiter //
create procedure p2()
begin
  declare x int  default 77;
  declare y char(10);
  set y="yaya";
  select x;
  select y;
end
//
delimiter ;
call p2();

select  @x
select  @y;

++++++++++++++++++++++++++++++++++++++++++++++++
delimiter //
create procedure p3()
begin
  declare x int  default 77;
  select x;
  select max(uid) into x from db9.user;
  select  x;
end
//
delimiter ;
call p3;

++++++++++++++++++++
delimiter //
create procedure p4()
begin
  declare x int;
  declare y int;
  declare z int;
  select count(shell) into x from db9.user where shell="/bin/bash";
  select count(shell) into y from db9.user where shell="/sbin/nologin";
  set  z=x+y;
  select z;
end
//
delimiter ;

#########################################
delimiter //
create procedure p5(in username char(20))
begin
    select name from db9.user where name=username;
end
//
delimiter ;
call  p5();
call  p5("tom");
call  p5("bob");
set @name="tom";
call p5(@name)
#################################

delimiter //
create procedure p6( out num int(2) )
begin
    select num;
    set num=7;
    select num;
    select count(name) into num from db9.user where shell!="/bin/bash";
    select num;
end
//
delimiter ;

call p6();
call p6(7);
set @x=1;
call p6(@x);
#####################################
delimiter //
create procedure p7( inout num int(2) )
begin
    select num;
    set num=7;
    select num;
    select count(name) into num from db9.user where shell!="/bin/bash";
    select num;
end
//
delimiter ;

set @x=1;
call p7(@x);
###########################################
delimiter //
create procedure p8( in num int(2) )
begin
    if num  <= 10 then
           select  * from db9.user where id <= num;
    end if;
end
//
delimiter ;

call p8(3);
call p8(7);
call p8(11);

#############################################
delimiter //
create procedure p9( in num int(2) )
begin
    if num  is null  then
           select  * from db9.user where id = 2;
    else
           select  * from db9.user where id <= num;

    end if;
end
//
delimiter ;
#############################
delimiter //
create procedure p11()
begin
   declare i int(2);
   declare j int(2);
   select count(id) into i  from db9.user;
   set j=1;
   while j <= i do
       if j % 2 = 0 then
          select * from db9.user where id = j;
       end if;
       set j=j+1;
   end while;
end
//
delimiter ;
call  p10();
##########################################
delimiter //
create procedure p12()
begin
   declare j int(2);
   set j=1;
   loop
        select j;
        set j=j+1;
   end loop;
end
//
delimiter ;

###############################################
delimiter //
create procedure p13()
begin
   declare j int(2);
   set j=1;
   repeat
        select j;
        set j=j+1;
        until j=6
   end repeat;
end
//
delimiter ;
#########################################
delimiter //
create procedure p14()
begin
   declare j int(2);
   set j=1;
   repeat
        select j;
        set j=j+1;
        until j=2
   end repeat;
end
//
delimiter ;

###############################
delimiter  //
create  procedure p15()
begin
   declare  i  int(2);
   set i = 0;
   loab1:while i < 10 do
       set i = i + 1;
       if i = 7 then
           ITERATE loab1;
       end if;
       select i;
   end while;
end
//
delimiter ;


delimiter  //
create  procedure p16()
begin
   declare  i  int(2);
   set i = 1;
   loab1:loop
       select i;
       set i = i + 1;
       LEAVE loab1;
   end loop;
end
//
delimiter ;

#############################
delimiter  //
create  procedure p17()
begin
   declare  i  int(2);
   set i = 1;
   loab1:loop
       select i;
       if i = 3 then
          LEAVE  loab1;
       end if;
       set i = i + 1;
   end loop;
end
//
delimiter ;








