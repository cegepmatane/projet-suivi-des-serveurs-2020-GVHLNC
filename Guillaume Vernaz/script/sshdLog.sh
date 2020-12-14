#!/bin/bash
timestamp(){ date +"%Y%m%d_%H%M%S"
}

surveillanceLog="sshdLog"$(timestamp)

LIGNE="*************************************************"

fichierLog="/var/log/auth.log" 
nom="sshd" 
anomalie="Disconnected from authenticating" 

nombreLigneAnomalies=$(tail -n 35 /var/log/auth.log | grep -c "Disconnected from authenticating") 
#tail -n 35 /var/log/auth.log | grep -c "Disconnected from authenticating"

lignesAnomalies=$(tail -n 35 /var/log/auth.log | grep "Disconnected from authenticating")

#Toutes les dates
tableauDates=($(echo $lignesAnomalies | grep -E -o "(\w{3}\s*\d{1,2}\s(\d{2}[:]?){3})"))
#Toutes les adresses IP
tableauIp=($(echo $lignesAnomalies | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | grep -v "51.161.33.181"))

#log apache2
for ((i = 0; i < $nombreLigneAnomalies; ++i)); do 
echo "$LIGNE 

Service: $nom 
Anomalie: $anomalie 
Date: ${tableauDates[$i]} 
Adressse Ip: ${tableauIp[$i]} 

" >> $surveillanceLog
done
