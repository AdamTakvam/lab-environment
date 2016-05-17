#!/bin/bash

# Force running as root
if [ $EUID -ne 0 ]
  then sudo $0
  exit
fi

yum -y install @virt* dejavu-lgc-* xorg-x11-xauth tigervnc libguestfs-tools policycoreutils-python bridge-utils 

# If you have use any directories other than /var/lib/libvirt for kvm files, set the selinux context. In this example I use /vm to store my disk image files.
semanage fcontext -a -t virt_image_t "/vm(/.*)?"; restorecon -R /vm 

# Allow packet forwarding between interfaces.
sed -i 's/^\(net.ipv4.ip_forward =\).*/\1 1/' /etc/sysctl.conf; sysctl -p 

# Optionally you can set up bridging which will allow guests to have a network adaptor on the same physical lan as the host. 
# In this example eth0 is the device to support the bridge and br0 will be the new device.
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

# Configure libvirtd service to start automatically and reboot.
chkconfig libvirtd on; shutdown -r now