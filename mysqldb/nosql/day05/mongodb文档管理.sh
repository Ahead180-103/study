#mongodb文档管理
#
#save()
#• 格式:db. 集合名 .save({ key:“ 值”, key:” 值” })
#
> db.c2.save({name:"bob",age:19})
WriteResult({ "nInserted" : 1 })

> db.c2.find()
{ "_id" : ObjectId("5b42d6e899dcbc9685bac75e"), "name" : "bob", "age" : 19 }

> db.c2.save({_id:7,name:"bob2",age:19})
WriteResult({ "nMatched" : 0, "nUpserted" : 1, "nModified" : 0, "_id" : 7 })

> db.c2.find()
{ "_id" : ObjectId("5b42d6e899dcbc9685bac75e"), "name" : "bob", "age" : 19 }
{ "_id" : 7, "name" : "bob2", "age" : 19 }

> db.c2.save({_id:7,name:"tom",age:19})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.c2.find()
{ "_id" : ObjectId("5b42d6e899dcbc9685bac75e"), "name" : "bob", "age" : 19 }
{ "_id" : 7, "name" : "tom", "age" : 19 }

#• 注意
#1、集合不存在时创建集合,后插入记录
#2、_id 字段值 已存在时 修改文档字段值
#3、_id 字段值 不已存在时 插入文档
#
insert()
• 格式:db. 集合名 .insert({key:“ 值”, key:” 值” })

> db.c2.insert ({_id:7,name:"bob"})
WriteResult({
	"nInserted" : 0,
	"writeError" : {
		"code" : 11000,
		"errmsg" : "E11000 duplicate key error collection: studb.c2 index: _id_ dup key: { : 7.0 }"
	}
})

> db.c2.insert ({_id:17,name:"bob"})
WriteResult({ "nInserted" : 1 })

> db.c2.find()
{ "_id" : ObjectId("5b42d6e899dcbc9685bac75e"), "name" : "bob", "age" : 19 }
{ "_id" : 7, "name" : "tom", "age" : 19 }
{ "_id" : 17, "name" : "bob" }
> 

• 注意
1、集合不存在时创建集合,后插入记录
2、_id 字段值 已存在时放弃插入
3、_id 字段值 不已存在时 插入文档

插入多条记录
> db.c6.insertMany([{name:"bob1",age:18},{name:"jerry",age:16,sex:"gri"}])
{
	"acknowledged" : true,
	"insertedIds" : [
		ObjectId("5b42da7d99dcbc9685bac75f"),
		ObjectId("5b42da7d99dcbc9685bac760")
	]
}
> db.c6.find()
{ "_id" : ObjectId("5b42da7d99dcbc9685bac75f"), "name" : "bob1", "age" : 18 }
{ "_id" : ObjectId("5b42da7d99dcbc9685bac760"), "name" : "jerry", "age" : 16, "sex" : "gri" }
> 

查询语法
• 显示所有行,默认一次只输出 20 行 输入 it 显示后续的行
– db. 集合名 .find()
• 显示第 1 行
– > db. 集合名 .findOne()
• 指定查询条件并指定显示的字段
– > db. 集合名 .find ( { 条件 },{ 定义显示的字段 } )
– > db.user.find({},{_id:0,name:1,shell:1})
– 0 不显示 1 显示
行数显示限制
• limit( 数字 ) // 显示前几行
> db. 集合名 .find().limit(3)

• skip( 数字 )	#// 跳过前几行
– > db. 集合名 .find().skip(2)
• sort( 字段名 ) 	#// 排序
– > db. 集合名 .find().sort(age:1|-1)  #// 1 升序 -1 降序
– > db.user.find({shell:"/sbin/nologin"},{_id:0,name:1,uid:1,shell:1}).skip(2).limit(2)

范围比较
– $in 在...里
– $nin 不在...里
– $or 或
#格式：db.c3.find({条件}，{显示字段})
#格式：db.c3.find({$or:[{条件1},{条件2}]},{显示的字段})
> db.user.find({uid:{$in:[1,6,9]}})

> db.c3.find({name:"root"},{_id:0,name:1})
#{ "name" : "root" }
> db.c3.find({name:"root",uid:1},{_id:0,name:1})
> db.c3.find({name:"root",uid:0},{_id:0,name:1})
#{ "name" : "root" }
> db.c3.find({uid:{$in:[1,6,9]}})
#{ "_id" : ObjectId("5b42fc5217400c7cabf341a3"), "name" : "bin", "password" : "x", "uid" : 1, "gid" : 1, "comment" : "bin", "homedir" : "/bin", "shell" : "/sbin/nologin" }
#{ "_id" : ObjectId("5b42fc5217400c7cabf341a8"), "name" : "shutdown", "password" : "x", "uid" : 6, "gid" : 0, "comment" : "shutdown", "homedir" : "/sbin", "shell" : "/sbin/shutdown" }
> db.c3.find({uid:{$in:[1,6,9]}},{_id:0,uid:1})
#{ "uid" : 1 }
#{ "uid" : 6 }
> db.c3.find({uid:{$in:[1,6,9]}},{_id:0,uid:1,name:1})
#{ "name" : "bin", "uid" : 1 }
#{ "name" : "shutdown", "uid" : 6 }
– > db.c3.find({uid:{$nin:[1,6,9]}})
– > db.c3.find({$or: [{name:"root"},{uid:1} ]})


> db.c3.find({$or:[{name:"root"},{name:"mysql"}]},{_id:0})

正则匹配
db.c3.find({字段名：/正则表达式/},{显示字段名})
db.c3.find({name:/root/},{_id:0,name:1})
db.c3.find({name:/^a/},{_id:0,name:1})

db.c3.find({name:/^....$/},{_id:0,name:1})


#数值比较
$lt	 $lte	 $gt  $gte 	$ne
< 	<= 	 > 	>=	!=

> db.c3.find({uid:3},{_id:0,name:1})
> db.c3.find({uid:{$gte:10,$lte:40}},{_id:0,name:1,uid:1}).sort({uid:1}).limit(1)  #//字段名uid大于10，小于40的，不显示_id,显示name和uid字段，sort（{uid:1}）是指按uid字段生序排序，


更新文档
update()语法格式
– > db. 集合名 .update({ 条件 },{ 修改的字段 } )	#//注意:把文件的其他字段都删除了,只留下了 password 字段, 且只修改与条件匹配的第 1 行 !!!
db.c3.find({uid:{$lte:3}},{_id:0})
db.c3.update({uid:{$lte:3}},{password:"AAA"})	#//默认把文件的其他字段都删除了
db.c3.find({password:"AAA"})

$set / $unset
• $set 条件匹配时,修改指定字段的值
– db.user.update({ 条件 },$set: { 修改的字段 })
db.c3.update({uid:{$lte:3}},{$set:{password:"FFF"}},false,true)

• $unset  删除文档指定的列
db.c3.update({uid:1},{$unset:{password:"FFF"}})
db.c3.find({uid:1},{_id:0})

• $inc 条件匹配时,字段值自加或自减
– Db. 集合名 .update({ 条件 },{$inc:{ 字段名 : 数字 }})	#//正整数自加 负整数自减!!!!
– db.c2.update({name:"bin"},{$inc:{uid:2}}) 字段值自加 2
– db.c3.update({name:"bin"},{$inc:{uid:-1}}) 字段自减 1
db.c3.update({name:"lisi"},{_id:0,name:1,uid:1}})
db.c3.find({name:"lisi"},{_id:0,name:1,uid:1})

$push / $addToSet
• $push 向数组中添加新元素
> db.user.insert({name:"bob",likes:["a","b","c","d","e","f"]})
WriteResult({ "nInserted" : 1 })
> db.user.find()
{ "_id" : ObjectId("5b4315f899dcbc9685bac761"), "name" : "bob", "likes" : [ "a", "b", "c", "d", "e", "f" ] }
> db.user.update({name:"bob"},{$push:{likes:"w"}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.user.find()
{ "_id" : ObjectId("5b4315f899dcbc9685bac761"), "name" : "bob", "likes" : [ "a", "b", "c", "d", "e", "f", "w" ] }
> db.user.update({name:"bob"},{$push:{likes:"w"}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.user.find()
{ "_id" : ObjectId("5b4315f899dcbc9685bac761"), "name" : "bob", "likes" : [ "a", "b", "c", "d", "e", "f", "w", "w" ] }
> 

• $addToSet 避免重复添加
– db. 集合名 .update({ 条件 },{$addToSet:{ 数组名 :"值" }}) 

> db.user.update({name:"bob"},{$addToSet:{likes:"f"}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 0 })
> db.user.find()
{ "_id" : ObjectId("5b4315f899dcbc9685bac761"), "name" : "bob", "likes" : [ "a", "b", "c", "d", "e", "f", "w", "w" ] }
> 

$pop /$pull
• $pop 从数组头部删除一个元素
> db.user.find()
{ "_id" : ObjectId("5b4315f899dcbc9685bac761"), "name" : "bob", "likes" : [ "a", "b", "c", "d", "e", "f", "w" ] }

> db.user.update({name:"bob"},{$pop:{likes:1}})		#//1 删除数组尾部元素 
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })

> db.user.find()
{ "_id" : ObjectId("5b4315f899dcbc9685bac761"), "name" : "bob", "likes" : [ "a", "b", "c", "d", "e", "f" ] }

> db.user.update({name:"bob"},{$pop:{likes:-1}})		#//-1 删除数组头部元素
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })

> db.user.find()
{ "_id" : ObjectId("5b4315f899dcbc9685bac761"), "name" : "bob", "likes" : [ "b", "c", "d", "e", "f" ] }
> 
#//1 删除数组尾部元素 -1 删除数组头部元素

• $pull 删除数组指定元素
#格式:db. 集合名 .update({ 条件 },{$pull:{ 数组名 : 值 }})
> db.user.find()
{ "_id" : ObjectId("5b4315f899dcbc9685bac761"), "name" : "bob", "likes" : [ "b", "c", "d", "e", "f" ] }

> db.user.update({name:"bob"},{$pull:{likes:"c"}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })

> db.user.find()
{ "_id" : ObjectId("5b4315f899dcbc9685bac761"), "name" : "bob", "likes" : [ "b", "d", "e", "f" ] }
>


$drop/$remove
• $drop 删除集合的同时删除索引
– db. 集合名 .drop( )
– db.user.drop( )

• remove() 删除文档时不删除索引,
– db. 集合名 .remove({})		# // 删除所有文档
– db. 集合名 .remove({ 条件 }) 	#// 删除与条件匹配的文档
– db.user.remove({uid:{$lte:10}})	
– db.user.remove({})


