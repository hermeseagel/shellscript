#!/bin/sh
timestamp=`date "+%Y%m%d%H%M"`
host=`hostname`
fpathname=$savepa
ftpserverip='172.16.15.46'
ftpuser='root'
ftpwd='root'
for u in $(lsuser -a ALL)
do 
last=`lsuser -a time_last_login $u |awk '/last_login/{print substr($2,17)}'`
echo ` printf "$u "; perl -le "print scalar(localtime($LAST))"`  >> /tmp/lastlogin$host$timestamp.log
done 
