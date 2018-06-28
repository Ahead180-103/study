#!/bin/bash
read -p "请输入文件或目录:  "  i
[ $# -eq 0 ] &&  exit
[ -f  $i ] && exit
[ -d  $i ] && exit
expect <<EOF
spawn  scp -r $i admin@www.svnup.cn:/home/admin/  
expect "password:"  {send "gauyao1125\n"}
expect "#"  {send "exit\n"}
EOF
