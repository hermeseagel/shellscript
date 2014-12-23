#!/bin/bash

for fn in `lsdev -Cc adapter | grep fc | awk '{ print $1}' `
do
lscfg -vl $fn |grep -i 'Network Address' | awk -F. '{print $2}'
done

for fn in `lsdev -Cc adapter | grep fc | awk '{ print $1}' `
do
wwn=`lscfg -vl $fn |grep -i 'Network Address' | awk -F. '{print $NF}'`
hostname=`hostname`
echo $hostname,$fn,$wwn
done