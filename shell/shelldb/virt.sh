#!/bin/bash
while :
do
echo -e "\033[32;1m If you dons,t want create virtualhost , please enter 回车\033[0m"
read -p "input hostname :  " name
[  -z  $name ] && echo -e "\033[31m please input hostname \033[0m" &&  exit
ls /var/lib/libvirt/images/$name.img &>/dev/null
[ $? -eq 0  ] && echo -e "\033[31m hostname exist\033[0m" && exit
qemu-img create -f qcow2 -b /var/lib/libvirt/images/.admin.qcow2  /var/lib/libvirt/images/${name}.img 20G
sleep 1
sed -r  "s/demo/${name}/" /root/.demo.xml  > /tmp/myvm.xml
sleep 1
virsh define /tmp/myvm.xml
done
