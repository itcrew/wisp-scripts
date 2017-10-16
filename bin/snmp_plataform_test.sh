#!/bin/bash
#
#
# Luciano Santos
# lucianosds [at] gmail.com
#
# 2017-10-14
#
ip1="192.168"
ip2=253
ip3=254
community="public"
vers="2c"
for ip2 in 253 252 153 152
do
    for ip3 in {1..254..1} 
    do
	ping -q -W1 -c1 $ip1.$ip2.$ip3 > /dev/null
	if [ $? -eq 0 ]
	then
	    RSTRING=`snmpget -v $vers -c $community $ip1.$ip2.$ip3 iso.3.6.1.2.1.1.1.0 | cut -d'"' -f2 | cut -d" " -f1`
	    echo "$RSTRING"
	    if [ "$RSTRING" != "RouterOS" ]
	    then
	        echo "ping $ip1.$ip2.$ip3"
	    fi
	fi
    done
done
