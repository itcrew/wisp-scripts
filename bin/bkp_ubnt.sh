#!/bin/bash
#
#
# Luciano Santos
# lucianosds [at] gmail.com
#
# 2017-10-14
#
# Reutilização de parte desse script
# https://wiki.mikrotik.com/wiki/Automatic_Centralized_Backup_from_Linux
#
# Para funcionar, favor instalar o sshpass. Caso utilize o ssh com chave pública, é necessário adaptar o script (sudo apt-get install sshpass).
LOGIN="ubnt"
#PASSWORD=$(awk 'NR == 1' pf) #read password from file named "pf"
PASSWORD="adm-7006"
SSHPORT=22
FTPPORT=21
#IPLISTFILE=mtlist #read ip addresses from this file - one address per line, end of line (press enter) after each
IPLIST="192.168"
OCTET3=254
BKPDIR="share/ubnt"
SUBDIR="/home/user/bkp_scripts" #directory where script store files
LOGFILE="client.log" #file to log
DTVAR=`date +"%Y%m%d"`
snmpc="public"
snmpv=1
HRVAR=`date`
ubntcomando="cat /tmp/system.cfg"
printf "Inicio do BKP dos UBNT de SITE_A às $HRVAR" >> $SUBDIR/$LOGFILE
#index=0
for OCTET3 in 253 252 153 152
do
    for i in {1..254..1}
    do
    IPVAR="$IPLIST.$OCTET3.$i"
    ping -q -W1 -c1 $IPVAR > /dev/null
    if [ $? -eq 0 ]
    then
	RSTRING=`snmpget -v $snmpv -c $snmpc $IPVAR iso.3.6.1.2.1.1.9.1.3.5 | cut -d'"' -f2 | cut -d' ' -f1`
        if [ "$RSTRING" = "Ubiquiti" ]
        then
	    VARR=`snmpget -v $snmpv -c $snmpc $IPVAR iso.3.6.1.2.1.1.5.0 | cut -d'"' -f2`
	    printf "\n|\n|\nBKP do UBNT $VARR $IPVAR" >> $SUBDIR/$LOGFILE
	    sshpass -p "$PASSWORD" ssh $LOGIN@$IPVAR -p $SSHPORT -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$ubntcomando" > $SUBDIR/$BKPDIR/$DTVAR-$VARR.cfg
        fi
    fi
    done
done
