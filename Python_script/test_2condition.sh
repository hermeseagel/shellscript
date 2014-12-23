#!/bin/ksh

function testping_s {
	#check standby Server network
	#if primary can"t  access also  gateway can"t access  mean standby Network have problem . 
	#if ping gateway work , ping primary can"t access  ,maybe Primary got problem 
	s_status=`ping  -c 5 $1 | awk "/packet loss/" | awk -F", " '{ if($3== "0% packet loss") print "Pass";else  print "Failed" }'`
	g_status=`ping  -c 5 $2 | awk "/packet loss/" | awk -F", " '{ if($3== "0% packet loss") print "Pass";else  print "Failed" }'`
	if [ "$s_status" == "Fail" ] && [ $g_stauts == "Fail" ]; then
		echo "Gateway and  remote partner can not access."
		echo "Check your setting on this script. or check you local ethernet"
	elif [ $s_status == "Pass" ] && [ $g_status == "Fail" ]; then 
		echo "GateWay can"t access , but can access partner."
	elif [ $s_status == "Fail" ] && [ $g_status == "Pass" ]; then
		echo "Can"t accees Partner , but gateway is fine."
	fi
}
ping -c 1 10.1.1.1 | awk "/packet loss/" | awk -F, '{print $3}'
ping -c 1 10.1.1.1 | awk "/packet loss/" | awk -F", " '{ if($3== "0% packet loss") print "Pass";else  print "Failed" }' 
testping_s $hbping_primary $hbping_gateway