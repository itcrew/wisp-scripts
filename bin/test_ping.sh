#!/bin/bash
#
#
# Luciano Santos
# lucianosds [at] gmail.com
#
# 2017-10-14
#
# -q quiet
# -c nb of pings to perform
ip1=192.168
ip2=154
ip3=254
ip=$ip1.$ip2.$ip3
while [ $ip3 -gt 240 ];do
	echo "ping $ip"
	ping -q -W1 -c1 $ip > /dev/null
 	if [ $? -eq 0 ]
	then
		echo "ok"
	fi
	ip3=`expr $ip3 - 1`
	ip=$ip1.$ip2.$ip3
done
