#!/bin/bash

OS="--os-variant=rhel6"
Net="--network bridge=br0"
Disk="--disk /media/vm-disks/swift-ctrl.img,bus=virtio,size=50"
Src="--cdrom /media/iso/CentOS-6.6-x86_64-minimal.iso"
KS=""
Gr="--graphics none"
CPU="--vcpus=2"
RAM="--ram=8192"
Name="swift-ctrl"

virt-install $OS $Net $KS $Disk $Src $Gr $CPU $RAM --name=$Name

# Set to start automatically when the host is booted
virsh autostart $Name
