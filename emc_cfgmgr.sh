#####################################################################
## emc_cfgmgr                                                      ##
## Directed Configuration for EMC storage devices.                 ##
## Copyright (c) 1999,2000,2002  EMC Corporation                   ##
## This utility supports Symmetrix Timefinder devices, Symmetrix   ##
## Timefinder devices under PowerPath 2.x,3.x and CLARiiON devices ##
## under PowerPath 3.x.                                            ##
## krichards V2.0.0.2 06/12/02                                     ##
#####################################################################
LANG=C
for PathType in scsi fchan fcs
do
	for PowerPath in `lsdev -Cc adapter -Fname | grep ${PathType}`
	do
		cfgmgr -vl ${PowerPath}

		if [ -f /usr/lpp/Symmetrix/bin/mkbcv ]
                then
 			/usr/lpp/Symmetrix/bin/mkbcv -a
		fi
	done
done

if [ -f /etc/methods/scan_for_scsi3clariion ]
then
	/etc/methods/scan_for_scsi3clariion 
fi

