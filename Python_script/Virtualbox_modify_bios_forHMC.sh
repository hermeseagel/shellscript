#!/bin/bash
#bios setting
vmname=HMCV7R790
VBoxManage setextradata $vmname "VBoxInternal/Devices/pcbios/0/Config/DmiSystemVendor" "IBM CORPORATION"
VBoxManage setextradata $vmname "VBoxInternal/Devices/pcbios/0/Config/DmiSystemProduct" "7042CR5"
VBoxManage setextradata $vmname "VBoxInternal/Devices/pcbios/0/Config/DmiSystemSerial" "string:066666"
VBoxManage setextradata $vmname "VBoxInternal/Devices/pcbios/0/Config/DmiSystemVersion" "7.3"
VBoxManage setextradata $vmname "VBoxInternal/Devices/pcbios/0/Config/DmiBoardVendor" "IBM CORPORATION"

VBoxManage modifyhd "/Volumes/MAC_BAKANDVMS/VM/HMCV7R790/HMCV7R790.vdi" --resize 146000