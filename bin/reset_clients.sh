#!/bin/bash
#
#https://wiki.mikrotik.com/wiki/Automatic_Centralized_Backup_from_Linux
#
# Install package "sshpass" before using this script (sudo aptitude install sshpass -y).
LOGIN=admin
#PASSWORD=$(awk 'NR == 1' pf) #read password from file named "pf"
PASSWORD="adm-7006"
SSHPORT=10022
FTPPORT=21
#IPLISTFILE=mtlist #read ip addresses from this file - one address per line, end of line (press enter) after each
IPLISTFILE="192.168.254.238"
SUBDIR=mikrotik #directory where script store files
LOGFILE=zalohatik.log #file to log
index=0
while read line ; do
IPLIST[$index]="$line"
index=$(($index+1))
done < $IPLISTFILE
echo ${iplist[@]}
for (( i=0; i<${#IPLIST[@]}; i++ ));
do
HOSTIP=${IPLIST[$i]}
echo  >>$LOGFILE
echo $HOSTIP `date +%Y%m%d%H%M%S` >>$LOGFILE
wget -N -nv -P $SUBDIR/$HOSTIP ftp://$HOSTIP:$FTPPORT/* --ftp-user=$LOGIN --ftp-password=$PASSWORD >>$LOGFILE  2>>$LOGFILE
sshpass -p $PASSWORD ssh $LOGIN@$HOSTIP -p $SSHPORT -o StrictHostKeyChecking=no ':global rmbackup [/file find type="backup"]; :foreach i in=$rmbackup do={:put [/file remove $i]}' >>$LOGFILE  2>>$LOGFILE
#sshpass -p $PASSWORD ssh $LOGIN@$HOSTIP -p $SSHPORT -o StrictHostKeyChecking=no ':global rmscript [/file find type="script"]; :foreach i in=$rmscript do={:put [/file remove $i]}' >>$LOGFILE  2>>$LOGFILE
sshpass -p $PASSWORD ssh $LOGIN@$HOSTIP -p $SSHPORT -o StrictHostKeyChecking=no ':global zalohafile ( [/ system identity get name] . "-" . [:pick [/ sys clock get date] 7 11] . [:pick [/ sys clock get date] 0 3] . [:pick [/ sys clock get date] 4 6] . "-" . [:pick [/ sys clock get time] 0 2] . [:pick [/ sys clock get time] 3 5] . [:pick [/ sys clock get time] 6 8]) ; / system backup save name=$zalohafile ; / export file=$zalohafile' >>$LOGFILE  2>>$LOGFILE
wget -N -nv -P $SUBDIR/$HOSTIP ftp://$HOSTIP:$FTPPORT/* --ftp-user=$LOGIN --ftp-password=$PASSWORD >>$LOGFILE  2>>$LOGFILE
done
