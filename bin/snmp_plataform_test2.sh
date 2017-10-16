#!/bin/bash
#
#
# Luciano Santos
# lucianosds [at] gmail.com
#
# 2017-10-14
#
#
dir_base="/home/user/bkp_scripts"
ipsf="$dir_base/share/ip_wisp.txt"
#ipsf="$dir_base/share/tmp_ip.txt"
ipst="$dir_base/share/ipc.txt"
commubnt="public"
commmkt="public"
n=0
i=0
cat $ipsf |  while read output
do
	mac=`snmpget -c $commubnt -v 1 "$output"  iso.3.6.1.2.1.2.2.1.6.2 | cut -d' ' -f4-9 --output-delimiter=':'`
	teste=`printf "$mac \n" | grep ":" | cut -c3`
	id=`snmpget -c $commubnt -v 1 "$output"  iso.3.6.1.2.1.1.5.0  | cut -d' ' -f4 | cut -d'"' -f2`
	if [ -z "$teste" ]
	then	
		echo "MKT"
		mac=`snmpget -c $commmkt -v 1 "$output"  iso.3.6.1.2.1.2.2.1.6.2 | cut -d' ' -f4-9 --output-delimiter=':'`
		id=`snmpget -c $commmkt -v 1 "$output"  iso.3.6.1.2.1.1.5.0  | cut -d' ' -f4 | cut -d'"' -f2`
		if [ "$i" -eq 0 ]
		then
			echo "$output $mac $id" > $ipst
		else
			echo "$output $mac $id" >> $ipst
		fi
		let "i++"
	else
		echo "UBNT"
		if [ "$i" -eq 0 ]
		then
			echo "$output $mac $id" > $ipst
		else
			echo "$output $mac $id" >> $ipst
		fi
		let "i++"
	fi
	printf "$n \n"
	let "n++"
done
