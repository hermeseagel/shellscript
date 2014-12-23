#!/usr/bin/ksh


usage()
{
        echo "Usage: test_hdisk_speed <disk_name>   #to run speed test on one disk"
        echo "       test_hdisk_speed <ALL>  #to run speed test on all disks"
}

get_speed()
{

Disk=$1

if [ "$Disk" == "all" ]
then
        disks=`fget_config -Av | grep hdisk | awk '{print $1}'`
        for disk in disks
        do
                get_speed $disk
        done
else
        echo "Performing speed test on $Disk..."
        ELAPSED=`timex dd if=/dev/${Disk} of=/dev/null bs=128k count=7810 2>&1 | grep real | awk '{ print $2 }
'`

        if [ $ELAPSED -lt 1 ]
        then
                echo "Problems while performing the speed test on ${Disk}, Check the disk ${Disk}"
                exit 1
        fi

        SPEED=`echo "1000 / $ELAPSED" | bc`
        echo "Duration: $ELAPSED secs."
        echo "Performance: $SPEED MB/sec."
fi
}


if [ $# -lt 1 ]
then
        usage
fi

case $1 in
        ALL)
                get_speed all
                ;;
        hdisk[1234567890])
                get_speed $1
                ;;
        *)
                usage
                ;;
esac
   usage
        