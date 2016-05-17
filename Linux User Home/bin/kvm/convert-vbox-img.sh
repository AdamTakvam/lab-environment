#!/bin/bash

if [ -z $1 ]
  then echo "You must supply the name of a VirtualBox VDI file to convert"
  exit 1
fi

qemu-img convert -f vdi -O qcow2 $1 $1.qcow2.img
