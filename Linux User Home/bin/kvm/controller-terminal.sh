#!/bin/bash

VM_Name="Controller"
virt-viewer --connect qemu_ssh://localhost/$VM_Name
