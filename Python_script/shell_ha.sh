#!/usr/bin/ksh


hbping_primary=8.8.8.8
hbping_gateway=10.1.1.1
check_process='pmon'
hbping_standby=''
vgname=''
mirgation_dirs=[/oracle,/data,]
loggerdirs=''
logfile=''
function testping_p {
	#check Primary network  status
	#if primary can not  access also  gateway can not access  mean standby Network have problem . 
	#if ping gateway work , ping primary can not access  ,maybe Primary got problem 
	p_status=`ping  -c 5 $hbping_primary | awk "/packet loss/" | awk -F", " '{ if($3== "0% packet loss") print "Pass";else print "Failed" }' `
	g_status=`ping  -c 5 $hbping_primary | awk "/packet loss/" | awk -F", " '{ if($3== "0% packet loss") print "Pass";else print "Failed" }' `
	if [ $p_status == "Fail" ] && [ $g_stauts == "Fail" ]; then
		echo 'Gateway and  remote partner can not access '
	fi
}

function check_pmon {
	ps -ef | grep  -i  $check_process |grep -v grep |  awk '{ print $1,$(NF) }' 
}
	
function removevg_primary {
for dir in mirgation_dirs
do
	check_fs=`fuser $dir 2>/dev/null | awk ' {print NF} ' `
	if [ $check_fs -eq 0 ]; then 
		
		umount $dir  
		varyoffvg $vgname
		exportvg $vgname

	elif [ $chek_fs -lt 2 ]; then
		fuser -ck $dir
	   umount $dir
		
	else 
		echo 'Stop umount'
		echo 'please check process all kill'
	fi
done 
		
}
function testping_s {
	#check standby Server network
	#if primary can not  access also  gateway can not access  mean standby Network have problem . 
	#if ping gateway work , ping primary can not access  ,maybe Primary got problem 
	#s_status standby server network status 
	#g_status gateway server network status 
	s_status=`ping  -c 5 $1 | awk "/packet loss/" | awk -F", " '{ if($3== "0% packet loss") print "Pass";else print "Failed" }'  `
	g_status=`ping  -c 5 $2 | awk "/packet loss/" | awk -F", " '{ if($3== "0% packet loss") print "Pass";else  print "Failed" }' `
	if [ "$s_status" == "Failed" ] && [ "$g_stauts" == "Failed" ]; then
		msg="Gateway and  remote partner can not access. Check your setting on this script. or check you local ethernet"
	elif [ $s_status == "Pass" ] && [ $g_status == "Failed" ]; then 
		msg="GateWay can not access , but can access partner."
	elif [ $s_status == "Failed" ] && [ $g_status == "Pass" ]; then
		msg= "can not accees Partner , but gateway is fine."
	fi 
	return $msg
}


ping_result=$(testping_s $hbping_primary $hbping_gateway)
echo $ping_result
