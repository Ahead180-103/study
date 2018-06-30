delimiter //
create procedure  say()
begin
select * from v1;
select * from user where name='mysql';
end
//

delimiter ;

call say();

show procedure status\G;

drop procedure say;

select * from mysql.proc ;
