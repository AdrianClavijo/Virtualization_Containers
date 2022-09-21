#!/bin/bash
#### Example
#### adrian@linux~$ ./CreateVMwithVBoxManage.sh UbuntuJammy Ubuntu_64 10240 1024 1 /home/adrian/Desktop/ubuntu-20.04.5-desktop-amd64.iso

#VM=$1 # Virtual Machine Name
#OS=$2 # Operative System Type
#HDSIZE=$3 # Size of Hard Disk
#RAMSIZE=$4 # Size of Ram
#CPUS=$5 # Quantity of CPU
#PATH=$6 # PATH of Iso file

echo "Virtual Machine Name: $1"
echo "Operative System Type: $2"
echo "Size of Hard Disk: $3 MB"
echo "Size of Ram: $4 MB"
echo "Quantity of CPU: $5"
echo "Virtual Machine Path: $6"

# VM name
VBoxManage createvm --name "$1" --register

# HD Space
VBoxManage createhd --filename "$1".vdi --size "$3" --format VDI

# Create controller for storage
VBoxManage storagectl "$1" --name "Storage Controller" --add sata

# Link Storage Controller
VBoxManage storageattach "$1" --storagectl "Storage Controller" --port 0 --device 0 --type hdd --medium "$1".vdi

VBoxManage storageattach "$1" --storagectl "Storage Controller" --port 1 --device 0 --type dvddrive --medium "$6"

# OS type
VBoxManage modifyvm "$1" --ostype "$2"

# Ram size
VBoxManage modifyvm "$1" --memory "$4"

# I/O APIC
VBoxManage modifyvm "$1" --ioapic on

# CPUs on VM
VBoxManage modifyvm "$1" --cpus "$5"

# how much the CPU can be used on VM
VBoxManage modifyvm "$1" --cpuexecutioncap 100

# Enables and disables the use of hardware virtualization extensions, such as Intel VT-x or AMD-V, if possible
VBoxManage modifyvm "$1" --hwvirtex on

# order of boot none|floppy|dvd|disk|net
VBoxManage modifyvm "$1" --boot1 dvd --boot2 disk --boot3 none --boot4 none

# # NET Type and enable
# if ["$NET" = "nat" ]|[ "$NET" ="NAT"]
# then
#	VBoxManage modifyvm $1 --nic1 nat --nat-network "10.20.1.20"
# else 
# 	echo "Define the host interface,ex:etho0: "
# 	read NNET
# 	VBoxManage modifyvm $VM --nic1 bridged
# 	VBoxManage modifyvm $VM --bridgeadapter1 $NNET
# fi
# Vram size
VBoxManage modifyvm "$1" --vram 128

# Start VM
VBoxManage startvm "$1"

echo "VM $1 Created and started with VBoxManage!!"
VBoxManage list vms
echo "VBoxManage command runned: VBoxManage list vms"
