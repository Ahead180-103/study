#!/bin/bash
git add --all
sleep 1
git commit -m "add"
sleep 1
expect <<EOF
spawn git push
expect ":" {send "github\n"}
expect ":" {send "123456\n"}
expect "#" {send "echo "欢迎下次光临"\n"}
expect "#" {send "exit\n"}
EOF
