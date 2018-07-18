#!/bin/bash
useradd -s /sbin/nologin nginx
yum -y install gcc make mariadb mariadb-server mariadb-devel php php-mysql 
cd /root/
tar -xf lnmp_soft.tar.gz
cd /root/lnmp_soft/
yum -y install php-fpm-5.4.16-42.el7.x86_64.rpm
tar -xf nginx-1.12.2.tar.gz 
cd nginx-1.12.2/
./configure --user=nginx --group=nginx  --with-http_ssl_module --with-stream --with-http_stub_status_module
make && make install
systemctl stop httpd

systemctl restart mariadb.service 
systemctl enable mariadb.service 
systemctl restart php-fpm.service
systemctl enable php-fpm.service
sleep 1
ln -s /usr/local/nginx/sbin/nginx  /usr/sbin/
killall nginx
sleep 1
nginx
cd /root/
sleep 1
echo "upstream webs {
     server 201.1.2.100:80 weight=2 max_fails=1 fail_timeout=30;
     server 201.1.2.200:80 max_fails=1 fail_timeout=30;
}" > upstream_file.txt

dizhi=`ifconfig eth2 | awk '/netmask/{print $2}'`
if [ $dizhi == "201.1.1.5" ] ;then
sed -ir  '/^http/r upstream_file.txt' /usr/local/nginx/conf/nginx.conf
nginx -s reload 
else
  exit
fi
rm -fr upstream_file.txt

