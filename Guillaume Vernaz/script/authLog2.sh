#!/bin/bash
timestamp(){
	date +"%Y%m%d_%H%M%S"
}

surveillanceLog="authLog-"$(timestamp)

LIGNE="*************************************************"

fichierLog="/var/log/auth.log"
nom="sshd"
anomalie="Failed password for root"

nombreLigneAnomalies=$(tail /var/log/auth.log | grep -c "Failed password for root")
lignesAnomalies=$(tail /var/log/auth.log | grep "Failed password for root")

#Toutes les dates
tableauDates=($(echo $lignesAnomalies | grep -E -o "([A-Za-z]{3}[ ][0-9]{2}[ ][0-9]{1,2}[\:][0-9]{1,2}[:][0-9]{1,2})"))
#Toutes les adresses IP
tableauIp=($(echo $lignesAnomalies | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}"))

#log sshd
for ((i = 0; i < 3; ++i)); do
echo "$LIGNE

Service: $nom
Anomalie: $anomalie
Date: ${tableauDates[$i]}
Adressse Ip: ${tableauIp[$i]}

" >> $surveillanceLog
done
