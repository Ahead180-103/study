知识点
一搭建MongoDB服务器
二常用管理命令
三基本数据类型
四数据备份
五数据导入导出

一、搭建MongoDB服务器免安装,解压后即可使用

[root@host50 ~]# mkdir /usr/local/mongodb
[root@host50 ~]# tar -zxf mongodb-linux-x86_64-rhel70-3.6.3.tgz

[root@host50 ~]# cp -r   mongodb-linux-x86_64-rhel70-3.6.3/bin /usr/local/mongodb/
[root@host50 ~]# cd /usr/local/mongodb/
[root@host50 mongodb]# mkdir etc
[root@host50 mongodb]# mkdir log
[root@host50 mongodb]# mkdir -p data/db

手动创建服务主配置文件

[root@host50 ~]# vim mongodb.conf
logpath=/usr/local/mongodb/log/mongodb.log
logappend=true        			# 追加的方式记录日志信息
dbpath=/usr/local/mongodb/data/db	# 数据库目录
fork=true					# 守护进程方式运行
bind_ip=192.168.4.50			# 指定连接ip地址
port=27050					# 指定端口号
:wq
[root@host50 ~]#  tail -2  /etc/profile
export PATH=/usr/local/mysql/bin:$PATH
export PATH=/usr/local/mongodb/bin:$PATH

启动服务
mongod -f /usr/local/mongodb/etc/mongodb.conf

查看进程
[root@host50 ~]# ps -C mongod

查看端口
[root@host50 ~]# netstat -utnlp | grep :27017
[root@host50 ~]#  tail -2  /etc/bashrc
alias mstart='mongod  -f /usr/local/mongodb/etc/mongodb.conf'
alias mstop='mongod --shutdown  -f /usr/local/mongodb/etc/mongodb.conf'

登陆 
#//格式： mongo --host  ip地址  --port  端口
[root@host50 ~]# mongo --host 192.168.4.50 --port 27050

>use studb
>db
show tables
>db.c1.save({name:"bob",age:19,sec:"girl"})
show tables
>db.c1.save({name:"bob",class:"nsd1803"})
>db.c1.find()

> db.c1.insert({name:"lucy",class:"nsd1803"})
WriteResult({ "nInserted" : 1 })
> db.c1.findOne()
{
	"_id" : ObjectId("5b405a0a2abd94f62cb8b56e"),
	"name" : "bob",
	"age" : 19,
	"sec" : "girl"
}
> db.c1.find({name:"bob"})
{ "_id" : ObjectId("5b405a0a2abd94f62cb8b56e"), "name" : "bob", "age" : 19, "sec" : "girl" }
> db.c1.remove({name:"bob"})
WriteResult({ "nRemoved" : 1 })
>


#字符  数值  布尔  数组  空
2018-07-07T14:33:12.268+0800 E QUERY    [thread1] SyntaxError: missing ; before statement @(shell):1:4
> db.c1.save({name:"bob",age:19,sigle:true})
WriteResult({ "nInserted" : 1 })
> db.c1.save
function (obj, opts) {
    if (obj == null)
        throw Error("can't save a null");

    if (typeof(obj) == "number" || typeof(obj) == "string")
        throw Error("can't save a number or string");

    if (typeof(obj._id) == "undefined") {
        obj._id = new ObjectId();
        return this.insert(obj, opts);
    } else {
        return this.update({_id: obj._id}, obj, Object.merge({upsert: true}, opts));
    }
}
> db.c1.save({name:"lucy",age:18,sigle:true,pay:null})
WriteResult({ "nInserted" : 1 })

#> db.c1.save({name:"bob",x:NUmber Int(3)})
#2018-07-07T14:36:31.115+0800 E QUERY    [thread1] SyntaxError: missing } after property list @(shell):1:32
> db.c1.save({name:"bob",x:NumberInt(3)})
WriteResult({ "nInserted" : 1 })

> db.c1.save({name:"bob",x:NumberInt(3)})
WriteResult({ "nInserted" : 1 })

> db.c1.save({name:"tom",x:NumberInt(3.99)})
2018-07-07T14:37:39.027+0800 E QUERY    [thread1] ReferenceError: NUmberInt is not defined :
@(shell):1:24

> db.c1.save({name:"tom",x:3.99})
WriteResult({ "nInserted" : 1 })

> db.c1.save({name:"yaya",bboy:["pyy","lyf","sxb"]})
WriteResult({ "nInserted" : 1 })

> db.c1.find()
{ "_id" : ObjectId("5b405a7b2abd94f62cb8b56f"), "name" : "lucy", "class" : "nsd1803" }
{ "_id" : ObjectId("5b405ee52abd94f62cb8b570"), "name" : "bob", "age" : 19, "sigle" : true }
{ "_id" : ObjectId("5b405f3d2abd94f62cb8b571"), "name" : "lucy", "age" : 18, "sigle" : true, "pay" : null }
{ "_id" : ObjectId("5b405fc62abd94f62cb8b572"), "name" : "tom", "x" : 3.99 }
{ "_id" : ObjectId("5b40600f2abd94f62cb8b573"), "name" : "yaya", "bboy" : [ "pyy", "lyf", "sxb" ] }

#代码 / 日期 / 对象
#代码
# 查询和文档中可以包括任何 JavaScript 代码
# {x: function( ){/* 代码 */}}
> db.c1.save({ lname:"php",codeformat:function(){/* <?php echo "hello word" ?> */}})

#日期
#日期被存储为自新纪元依赖经过的毫秒数,不存储时区
#{x:new Date( )}
> db.c1.save({name:"lilei",birthday: new Date() })
> db.c1.find({name:"lilei"})
{ "_id" : ObjectId("5b4063832abd94f62cb8b575"), "name" : "lilei", "birthday" : ISODate("2018-07-07T06:53:55.891Z") }

#对象
#对象 id 是一个 12 字节的字符串,是文档的唯一标识
#{x: ObjectId() }
> db.c1.save({name:"alilei",stuid:ObjectId()})
> db.c1.find()

#内嵌类型
#文档可以嵌套其他文档,被嵌套的文档作为值来处理
#{tarena: {address:“Beijing”,tel:“888888”,person:”hanshaoyun”}}
> db.c1.save({ywzd:{p:"dmy",jg:69,v:2},ngsfc:{p:"bredg",jg:89,v:3}})
WriteResult({ "nInserted" : 1 })

> db.c1.save({ywzd:{p:"dmy",jg:69,v:2},ygsfc:{p:"bredg".jg:89,v:3}})
2018-07-07T15:28:59.660+0800 E QUERY    [thread1] SyntaxError: missing } after property list @(shell):1:56

#正则表达式
#查询时,使用正则表达式作为限定条件
#{x:/ 正则表达式 /}
> db.c1.save({name:"hanmm",/^a/})	#错误信息
2018-07-07T15:32:55.460+0800 E QUERY    [thread1] SyntaxError: invalid property id @(shell):1:25
> 
> db.c1.save({ name:"hanmm",match:/^a/ })
WriteResult({ "nInserted" : 1 })

#数据恢复：
#数据导出
语法格式 1
#mongoexport [--host IP 地址 --port 端口 ] -d 库名 -c 集合名 -f 字段名 1, 字段名 2  --type=csv > 目录名 /文件名 .csv

语法格式 2
#mongoexport --host IP 地址 --port 端口 库名 -c 集合名 -q ‘{ 条件 }’ -f 字段名1 ,字段名2  --type=csv > 目录名 /文件名 .csv
#注意:导出为 csv 格式必须使用 -f 指定字段名列表 !!!,不指定列名就报错
[root@host50 ~]# mongoexport --host 192.168.4.50   --port 27050  -d studb   -c c1 -f _id,name   --type=csv  > /mongodbdir/c1.csv
2018-07-07T16:33:35.370+0800	connected to: 192.168.4.50:27050
2018-07-07T16:33:35.372+0800	exported 12 records
[root@host50 ~]# cat /mongodbdir/c1.csv
_id,name
ObjectId(5b405a7b2abd94f62cb8b56f),lucy
ObjectId(5b405ee52abd94f62cb8b570),bob
ObjectId(5b405f3d2abd94f62cb8b571),lucy
ObjectId(5b405fc62abd94f62cb8b572),tom
ObjectId(5b40600f2abd94f62cb8b573),yaya
ObjectId(5b40621a2abd94f62cb8b574),
ObjectId(5b4063832abd94f62cb8b575),lilei
ObjectId(5b4063f22abd94f62cb8b576),bob
ObjectId(5b40643a2abd94f62cb8b577),bob
ObjectId(5b4065f52abd94f62cb8b579),alilei
ObjectId(5b406bdb2abd94f62cb8b57a),
ObjectId(5b406ce62abd94f62cb8b57b),hanmm
[root@host50 ~]# 

语法格式 3
#mongoexport [ --host IP 地址 --port 端口 ] -d 库名 -c 集合名 [ -q ‘{ 条件 }’ –f 字段列表] --type=json  > 目录名 /文件名 .json

[root@host50 ~]# mkdir /mongodbdir
[root@host50 ~]# mongoexport --host 192.168.4.50  --port 27050  -d studb -c c1   --type=json  >/mongodbdir/c1.json
2018-07-07T15:56:09.443+0800	connected to: 192.168.4.50:27050
2018-07-07T15:56:09.443+0800	exported 12 records
[root@host50 ~]# cat /mongodbdir/c1.json


#数据导入
[root@host50 ~]# mongoimport --host 192.168.4.50 --port 27050  -d bbsdb -c  t1  --type=json  /mongodbdir/c1.json 
2018-07-07T16:22:44.798+0800	connected to: 192.168.4.50:27050
2018-07-07T16:22:44.980+0800	imported 12 documents
[root@host50 ~]# 
[root@host50 ~]# mongo --host 192.168.4.50  --port 27050 
> show dbs
admin   0.000GB
bbsdb   0.000GB
config  0.000GB
local   0.000GB
studb   0.000GB
> use bbsdb
switched to db bbsdb
> show tables
t1
> db.t1.find()
{ "_id" : ObjectId("5b405a7b2abd94f62cb8b56f"), "name" : "lucy", "class" : "nsd1803" }
{ "_id" : ObjectId("5b405ee52abd94f62cb8b570"), "name" : "bob", "age" : 19, "sigle" : true }
{ "_id" : ObjectId("5b405f3d2abd94f62cb8b571"), "name" : "lucy", "age" : 18, "sigle" : true, "pay" : null }
{ "_id" : ObjectId("5b405fc62abd94f62cb8b572"), "name" : "tom", "x" : 3.99 }
{ "_id" : ObjectId("5b40600f2abd94f62cb8b573"), "name" : "yaya", "bboy" : [ "pyy", "lyf", "sxb" ] }
{ "_id" : ObjectId("5b40621a2abd94f62cb8b574"), "lname" : "php", "codeformat" : { "code" : "function (){/* <?php echo \"hello word\" ?> */}" } }
{ "_id" : ObjectId("5b4063832abd94f62cb8b575"), "name" : "lilei", "birthday" : ISODate("2018-07-07T06:53:55.891Z") }
{ "_id" : ObjectId("5b4063f22abd94f62cb8b576"), "name" : "bob", "x" : 3 }
{ "_id" : ObjectId("5b40643a2abd94f62cb8b577"), "name" : "bob", "x" : 3 }
{ "_id" : ObjectId("5b4065f52abd94f62cb8b579"), "name" : "alilei", "stuid" : ObjectId("5b4065f52abd94f62cb8b578") }
{ "_id" : ObjectId("5b406bdb2abd94f62cb8b57a"), "ywzd" : { "p" : "dmy", "jg" : 69, "v" : 2 }, "ngsfc" : { "p" : "bredg", "jg" : 89, "v" : 3 } }
{ "_id" : ObjectId("5b406ce62abd94f62cb8b57b"), "name" : "hanmm", "match" : /^a/ }
> db.t1.count()
12
>

#导入csv数据
[root@host50 ~]# mongoimport --host 192.168.4.50   --port 27050  -d bbsdb   -c t2 -f _id,name  --type=csv /mongodbdir/c1.csv   #//会导入字段名（标题）
2018-07-07T16:50:59.563+0800	connected to: 192.168.4.50:27050
2018-07-07T16:50:59.564+0800	imported 12 documents

[root@host50 ~]# mongoimport --host 192.168.4.50   --port 27050  -d studb  -c c1 --headerline --drop   --type=csv   /mongodbdir/c1.csv


#导入/etc/passwd文件
> use studb
switched to db studb

> db.c3.save({name:"yaya",password:"x",uid:88888,gid:99999,comment:"teacher",homedir:"/home/yaya",shell:"/bin/bash"})

[root@host50 ~]# mongoexport --host 192.168.4.50  --port 27050  -d studb  -c  c3 -f name.password,uid,gid,comment,homedir,shell  --type=csv >/mongodbdir/c3.csv
2018-07-07T17:33:02.418+0800	connected to: 192.168.4.50:27050
2018-07-07T17:33:02.418+0800	exported 1 record

[root@host50 ~]#  cp /etc/passwd  /mongodbdir/c3.csv
[root@host50 mongodbdir]# sed -i  '$r  passwd'  c3.csv     #//将passwd文件里面的内容读如到c3.csv中
[root@host50 mongodbdir]# vim c3.csv
[root@host50 mongodbdir]# sed -i 's/:/,/' c3.csv
[root@host50 mongodbdir]# vim c3.csv
[root@host50 mongodbdir]# sed -i 's/:/,/g' c3.csv
[root@host50 mongodbdir]# vim c3.cs

[root@host50 ~]# mongoimport --host 192.168.4.50  --port 27050  -d studb  -c  c3  --headerline  --drop   --type=csv  /mongodbdir/c3.csv	#//--headerline 导入数据时，若库合集合不存在，则先创建库和集合后再导入数据；若库和集合已存在，则以追加的方式导入数据到集合里；--drop选项可以删除原有数据后导入新数据，--headerline 忽略标题

mkdir /bakmongo
mongodump --host 192.1638.4.50  --port 27050  -d studb  -c c3  -o /bakmongo
ls /bakmongo

