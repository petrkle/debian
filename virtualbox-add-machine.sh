#!/bin/bash
# add new debian machine to VirtualBox

set -e

TMP=$HOME/tmp
ISO=$TMP/debian-7.5.0-i386-netinst.iso
VMDIR=$TMP/virtual-box
RAM=2048
HDD=20000

[ -d $VMDIR ] || mkdir -p $VMDIR

[ -f $ISO ] || wget -O $ISO http://cdimage.debian.org/debian-cd/7.5.0/i386/iso-cd/debian-7.5.0-i386-netinst.iso

[ -z "$1" ] && ID="debian-$RANDOM" || ID=$1

vboxmanage createvm --name $ID --ostype Debian --register

vboxmanage modifyvm $ID --memory $RAM

vboxmanage modifyvm $ID --bridgeadapter1 eth0

vboxmanage modifyvm $ID --nic1 bridged

vboxmanage createhd --filename $VMDIR/$ID.vdi --size $HDD --format VDI

vboxmanage storagectl $ID --name "SATA Controller" --add sata --controller IntelAhci

vboxmanage storageattach $ID --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $VMDIR/$ID.vdi

vboxmanage storagectl $ID --name "IDE Controller" --add ide --controller PIIX4

vboxmanage storageattach $ID --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium $ISO

vboxmanage modifyvm $ID --vrdemulticon on --vrdeport 3390

vboxmanage modifyvm $ID --vram 16
