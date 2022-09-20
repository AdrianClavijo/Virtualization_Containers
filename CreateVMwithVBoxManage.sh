#!/bin/bash
#### Example
#### adrian@linux~$ ./CreateVMwithVBoxManage.sh UbuntuJammy Ubuntu 2024 1024 1 /home/adrian/Desktop/ubuntu-20.04.5-desktop-amd64.iso

VM=$1 # Virtual Machine Name
OS=$2 # Operative System Type
HDSIZE=$3 # Size of Hard Disk
RAMSIZE=$4 # Size of Ram
CPUS=$5 # Quantity of CPU
PATH=$6 # PATH of Iso file

echo "Virtual Machine Name: $1"
echo "Operative System Type: $2"
echo "Size of Hard Disk: $3 MB"
echo "Size of Ram: $4 MB"
echo "Quantity of CPU: $5"
echo "Virtual Machine Path: $6"

# VM name
vboxmanage createvm --name $VM --register

# HD Space
vboxmanage createhd --filename $VM.vdi --size $HDSIZE --format VDI

# Create controller for storage
vboxmanage storagectl $VM --name "Storage Controller" --add ide

# Link Storage Controller
vboxmanage storageattach $VM --storagectl "Storage Controller" --port 0 --device 0 --type hdd --medium $VM.vdi

# OS type
vboxmanage modifyvm $VM --ostype $OS

# Ram size
vboxmanage modifyvm $VM --memory $RAMSIZE

# I/O APIC
vboxmanage modifyvm $VM --ioapic on

# CPUs on VM
vboxmanage modifyvm $VM --cpus $CPUS

# how much the CPU can be used on VM
vboxmanage modifyvm $VM --cpuexecutioncap 100

# Enables and disables the use of hardware virtualization extensions, such as Intel VT-x or AMD-V, if possible
vboxmanage modifyvm $VM --hwvirtex on

# order of boot none|floppy|dvd|disk|net
vboxmanage modifyvm $VM --boot1 disk --boot2 none --boot3 none --boot4none

# # NET Type and enable
# if ["$NET" = "nat" ]|[ "$NET" ="NAT"]
# then
vboxmanage modifyvm $VM --nic1 nat --nat-network "10.20.1.20"
# else 
# 	echo "Define the host interface,ex:etho0: "
# 	read NNET
# 	VBoxManage modifyvm $VM --nic1 bridged
# 	VBoxManage modifyvm $VM --bridgeadapter1 $NNET
# fi

# Vram size
vboxmanage modifyvm $VM --vram 128

# Start VM
vboxmanage startvm $VM

echo "VM $1 Created and started with VBoxManage!!"
vboxmanage list vms
echo "VBoxManage command runned: VBoxManage list vms"