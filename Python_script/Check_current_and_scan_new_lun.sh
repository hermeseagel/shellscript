#!/bin/sh
recdate=`date +"%Y-%m-%d-%H:%M"`
#list current disk 
echo 'Listdisk Record date' $recdate > /tmp/listdisk.log
lsdev -Cc disk | awk '{ print $1}' >> /tmp/diskrecord.log
echo 'end of Listdisk' $recdate > /tmp/listdisk.log

echo 'Record date' $recdate > /tmp/vgdisks.log
lspv |awk '{print "before_add_lun", $(NF-1), $1 ,$(NF)}' >> /tmp/vgdisks.log
echo 'finish' $recdate  >> /tmp/vgdisks.log
#scan new lun disk 
cfgmgr -v >> /tmp/found_lun.log 
lsdev -Cc disk | awk 
lspv |awk '{if($(NF-1) !="rootvg" ) print "Current", $(NF-1), $(NF) }' >> /tmp/vgdisk.log