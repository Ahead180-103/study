#!/bin/bash
innobackupex -uyaya -p123456 --databases 'bbsdb.user mysql sys performance_schema'   /bakmysql/allbakuser-`date +%F`.sql  --no-timestamp
