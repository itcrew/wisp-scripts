#!/bin/bash
#
#
# Luciano Santos
# lucianosds [at] gmail.com
#
# 2017-10-14
#
# Para funcionar, favor instalar o sshpass. Caso utilize o ssh com chave pública, é necessário adaptar o script (sudo apt-get install sshpass).
#
#
#
PASSWORD="password"
LOGIN="login"
SSHPORT=22
i="192.168"
j=254
z=1
log="~/client_desconect.log"
echo "Iniciando desconexão de clientes" > $log
while[ $j < 255 ];do
	echo "Desconectando clientes da Routerboard $i.$j.$z" >> $log
	sshpass -p $PASSWORD ssh $LOGIN@$i.$j.$z -p $SSHPORT -o StrictHostKeyChecking=no -o ConnectTimeout=15 '/ppp active print count-only' >> $log
	sshpass -p $PASSWORD ssh $LOGIN@$i.$j.$z -p $SSHPORT -o StrictHostKeyChecking=no -o ConnectTimeout=15 '/ppp active remove [find service="pppoe"]' 
	sshpass -p $PASSWORD ssh $LOGIN@$i.$j.$z -p $SSHPORT -o StrictHostKeyChecking=no -o ConnectTimeout=15 '/ppp active print count-only' >> $log
	sshpass -p $PASSWORD ssh $LOGIN@$i.$j.$z -p $SSHPORT -o StrictHostKeyChecking=no -o ConnectTimeout=15 '/ppp active print' >> $log
	let "z++"
done
