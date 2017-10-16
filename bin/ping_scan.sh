#!/bin/bash
#for ip in $(seq 1 254); do ping -c 1 192.168.252.$ip>/dev/null; [ $? -eq 0 ] && echo "192.168.252.$ip UP" || : ; done
fping -r 1 -a -g $1/$2 >> ips_scanned.txt
