#!/bin/bash
#read -p "进入那台:" num
for num in `seq 10`
do
expect <<EOF
spawn ssh -o StrictHostKeyChecking=no  -X  root@192.168.4.$num
expect "password:" {send "1\n"}
expect "#" {send "touch /gaoyong.txt\n"}
expect "#" {send "exit\n"}
EOF
done


