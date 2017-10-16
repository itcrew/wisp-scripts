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
LOGIN="login"
PASSWORD="password"
SSHPORT=22
FTPPORT=21
#IPLISTFILE=mtlist #le os IPs de um arquivo
IPLIST="192.168"
OCTET3=254
BKPDIR="share/mikrotik"
SUBDIR="/home/user/bkp_scripts" 
LOGFILE="client.log" 
DTVAR=`date +"%Y%m%d"`
COMMUNITY="public"
HRVAR=`date`
printf "Inicio do BKP dos Roteadores do SITE_A às $HRVAR" >> $SUBDIR/$LOGFILE
echo $DTVAR
echo $HRVAR
#index=0
for (( i=254; i>230 ; i--));
do
    IPVAR="$IPLIST.$OCTET3.$i"
    ping -q -W1 -c1 $IPVAR > /dev/null
    if [ $? -eq 0 ]
    then
    	echo "ping $IPVAR"
	VARR=`snmpget -v 2c -c $COMMUNITY $IPVAR iso.3.6.1.2.1.1.5.0 | cut -d'"' -f2`
	printf "\n|\n|\nBKP do Roteador $VARR $IPVAR" >> $SUBDIR/$LOGFILE
	sshpass -p $PASSWORD ssh $LOGIN@$IPLIST.$OCTET3.$i -p $SSHPORT -o StrictHostKeyChecking=no -o ConnectTimeout=5 '/export' >> $SUBDIR/$BKPDIR/$DTVAR-$VARR
   fi
done
printf "Inicio do BKP dos Roteadores de SITE_B às $HRVAR" >> $SUBDIR/$LOGFILE
OCTET3=154
COMMUNITY="public"
for (( i=254; i>245 ; i--));
do
    IPVAR="$IPLIST.$OCTET3.$i"
    ping -q -W1 -c1 $IPVAR > /dev/null
    if [ $? -eq 0 ]
    then
	echo "ping $IPVAR"
	if [ $i -eq 254 ]
	then
		VARR="NC-PF"
		printf "\n|\n|\nBKP do Roteador $VARR $IPVAR" >> $SUBDIR/$LOGFILE
		sshpass -p $PASSWORD ssh $LOGIN@$IPLIST.$OCTET3.$i -p $SSHPORT -o StrictHostKeyChecking=no -o ConnectTimeout=5 '/export' >> $SUBDIR/$BKPDIR/$DTVAR-$VARR
	else
		VARR=`snmpget -v 2c -c $COMMUNITY $IPVAR iso.3.6.1.2.1.1.5.0 | cut -d'"' -f2`
		printf "\n|\n|\nBKP do Roteador $VARR $IPVAR" >> $SUBDIR/$LOGFILE
		sshpass -p $PASSWORD ssh $LOGIN@$IPLIST.$OCTET3.$i -p $SSHPORT -o StrictHostKeyChecking=no -o ConnectTimeout=5 '/export' >> $SUBDIR/$BKPDIR/$DTVAR-$VARR
	fi
    fi
done
rm  $SUBDIR/$BKPDIR/$DTVAR-

printf "Fim do BKP às $HRVAR" >> $SUBDIR/$LOGFILE
