#!/bin/sh
#### Example
#### adrian@linux~$ ./CreateVMwithVBoxManage.sh UbuntuJammy Ubuntu 2024 1024 1 nat /home/adrian/Desktop/ubuntu-20.04.1-desktop-amd64.iso

VM=$1 # Maquina Virtual Name
OS=$2 # Operative System Typr
HDSIZE=$3 # Size of Hard Disk
RAMSIZE=$4 # Size of Ram
CPUS=$5 # Quantity of CPU
NET=$6 #Name of Host Adaptor
PATH=$8 # PATH of Iso file

# Lee confirmacion del usuario
echo "Continue with installation? y/N : "
read continua

# Valida la respuesta del usuario
if [ "$continua" = "y" ]
then
	echo "Creating VM $1"

	# VM name
	VBoxManage createvm --name $VM --register

	# HD Space
	VBoxManage createhd --filename $VM.vdi --size $HDSIZE --format VDI

	# Create controller for storage
	VBoxManage storagectl $VM --name "Storage Controller" --add ide

	# Link Storage Controller
	VBoxManage storageattach $VM --storagectl "Storage Controller" --port 0 --device 0 --type hdd --medium $VM.vdi

	# OS type
	VBoxManage modifyvm $VM --ostype $OS

	# Ram size
	VBoxManage modifyvm $VM --memory $RAMSIZE

	# I/O APIC
	VBoxManage modifyvm $VM --ioapic on

	# CPUs on VM
	VBoxManage modifyvm $VM --cpus $CPUS

	# how much the CPU can be used on VM
	VBoxManage modifyvm $VM --cpuexecutioncap 100

	# Enables and disables the use of hardware virtualization extensions, such as Intel VT-x or AMD-V, if possible
	VBoxManage modifyvm $VM --hwvirtex on

	# order of boot none|floppy|dvd|disk|net
	VBoxManage modifyvm $VM --boot1 disk --boot2 none --boot3 none --boot4none

	# NET Type and enable
	if ["$NET" = "nat" ]|[ "$NET" ="NAT"]
	then
		VBoxManage modifyvm $VM --nic1 nat
	else 
		echo "Define the host interface,ex:etho0: "
		read NNET
		VBoxManage modifyvm $VM --nic1 bridged
		VBoxManage modifyvm $VM --bridgeadapter1 $NNET
	fi
	# Vram size
	VBoxManage modifyvm $VM --vram 128

	# Start VM
	VBoxManage startvm $VM

	echo "VM $1 Created and started with VBoxManage!!"
	VBoxManage list vms
	echo "VBoxManage command runned: VBoxManage list vms"
else
	echo "Create VM:$1 Cancelled"
fi