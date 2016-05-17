#!/bin/bash

chkconfig network on
service network restart
yum -y erase NetworkManager
cp -p /etc/sysconfig/network-scripts/ifcfg-{eth0,br0}
sed -i -e'/HWADDR/d' -e'/UUID/d' -e's/eth0/br0/' -e's/Ethernet/Bridge/' \
/etc/sysconfig/network-scripts/ifcfg-br0
echo DELAY=0 >> /etc/sysconfig/network-scripts/ifcfg-br0
echo 'BOOTPROTO="none"' >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo BRIDGE=br0 >> /etc/sysconfig/network-scripts/ifcfg-eth0
service network restart
brctl show
