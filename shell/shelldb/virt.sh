#!/bin/bash
read -p "input name :  " name
#[ $# -eq 0 ] && echo "input name" &&  exit
ls /var/lib/libvirt/images/$name.img &>/dev/null
[ $? -eq 0  ] && echo "name exist" && exit
qemu-img create -f qcow2 -b /var/lib/libvirt/images/.admin.qcow2  /var/lib/libvirt/images/${name}.img 20G
sleep 1
sed -r  "s/demo/${name}/" /root/demo.xml  > /tmp/myvm.xml
sleep 1
virsh define /tmp/myvm.xml
