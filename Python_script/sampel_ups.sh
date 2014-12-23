#!/bin/bash

#!/usr/bin/sh	
#it is for stop ebs prod env script.

#su - testmgr  "-c /home/testmgr/stop_ap_TEST.sh" 
sleep 30
export port=1521 
#check EBS  AP  process is still work or not 
until [ `ps -ef  | grep -i ora |grep -v grep | wc -l  ` -eq  0 ]  
do
if [ `ps -ef  | grep -i ora | grep -i smon | wc -l `  != 0 ] ; then 
	for i in `ps -ef  | grep -i ora | grep -i smon  | awk '{ print $2 }' `
	do
	echo 'kill' $i
	done
	echo "su - prodmgr -c /etc/hacmp/stop_db_TEST.sh"
	else
	echo "-elese su - prodmgr -c /etc/hacmp/stop_db_TEST.sh"
	fi
done

#check all service are  shutdown  , then poweroff AIX server
export port=1521
if [  `ps -ef  | grep pmon |  grep -v grep |awk '{print $9 }' | wc -l ` == 0 ] && [ `netstat -an | grep $port | wc -l ` == 0 ] ; then
echo 'shutdown -F' 
else
echo 'db still work'
fi
