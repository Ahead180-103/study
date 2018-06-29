#!/bin/bash
[ $# -eq 0 ] &&  echo  "请输入文件或目录:  " && exit
#[ -e $i ] && exit
#[ -f  $i ] && exit
#[ -d  $i ] && exit
expect <<EOF
set timeout 100
spawn  scp -r $1 admin@www.tarena.cn:/home/admin/  
expect "password:"  {send "123\n"}
expect "#"  {send "exit\n"}
EOF
