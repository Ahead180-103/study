#!/bin/bash
git add --all
sleep 1
git commit -m "add"
sleep 1
expect <<EOF
set timeout 50
spawn git push
expect ":" {send "github\n"}
expect ":" {send "123456\n"}
expect "#" {send "echo "Thanks and look farwad your coming next time."\n"}
expect "#" {send "exit\n"}
EOF
