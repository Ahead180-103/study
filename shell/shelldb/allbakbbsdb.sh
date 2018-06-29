#!/bin/bash
w=`date +%w`
if [ $w -eq 1 ] ;then
innobackupex -uyaya -p123456 --databases 'bbsdb mysql sys performance_schema'   /bakmysql/allbakbbsdb.sql  --no-timestamp
elif [ $w -eq 2 ];then
innobackupex -uyaya -p123456 --databases 'bbsdb mysql sys performance_schema'  --incremental  /bakmysql/new$[w-1]dir   --incremental-basedir=/bakmysql/allbakbbsdb.sql  --no-timestamp
elif [ $w -eq 0 ];then
innobackupex -uyaya -p123456 --databases 'bbsdb mysql sys performance_schema'  --incremental  /bakmysql/new6dir   --incremental-basedir=/bakmysql/new5dir  --no-timestamp
else
innobackupex -uyaya -p123456 --databases 'bbsdb mysql sys performance_schema'  --incremental  /bakmysql/new$[w-1]dir   --incremental-basedir=/bakmysql/new$[w-2]dir  --no-timestamp
fi
