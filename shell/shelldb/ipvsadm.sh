#!/bin/bash
while :
do
   for i in 192.168.4.{2,3}
   do
     ipvsadm -Ln | grep $i  &>/dev/null
     web_in_lvs=$?
     curl $i &>/dev/null
     web_stat=$?
     if [ $web_stat -ne  0 -a $web_in_lvs -eq 0  ];then
     ipvsadm -d -t 201.1.1.4:80 -r $i  &>/dev/null
     elif [ $web_stat -eq 0 -a $web_in_lvs -ne 0 ];then
     ipvsadm -a -t 201.1.1.4:80 -r $i -m  &>/dev/null
     fi
   done
sleep 5
done

