#!/bin/bash
#$1为主机名
read -p '请输入网卡名如0,1等：' num
read -p '请输入主机名：' user

rm -fr /etc/yum.repos.d/*.repo
a=`ifconfig eth$num | awk '/netmask/{print $2}'`
ip=${a%.*}
yum_install (){
echo "[dvd]
name=rhel7
baseurl=http://$ip.254/rhel7
enabled=1
gpgcheck=0" > /etc/yum.repos.d/dvd.repo
}

yum_install
yum clean all > /dev/null
sleep 0.5
yum repolist 


hostnamectl set-hostname $user

echo 1 | passwd --stdin root

#tar -xf /root/lnmp_soft.tar.gz 
