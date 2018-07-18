#!/bin/bash
read -p "请输入网卡名如eth1:" i
read -p "请输入网卡名如ip:" j
nmcli connection add type ethernet con-name $i ifname $i
nmcli connection modify $i ipv4.method manual ipv4.addresses $j/24 connection.autoconnect yes
nmcli connection up $i
