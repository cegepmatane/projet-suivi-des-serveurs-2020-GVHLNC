#!/bin/bash
timestamp(){
	date +"%Y%m%d_%H%M%S"
}

surveillanceLog="logSurveillance-"$(timestamp)

LIGNE="*************************************************"

fichierLog="/var/log/apache2/access.log.1"
nom="apache2"
anomalie="404"

nombreLigneAnomalies=$(tail -n 35 $fichierLog | grep -c $anomalie)
lignesAnomalies=$(tail -35 $fichierLog | grep $anomalie)

#Toutes les dates
tableauDates=($(echo $lignesAnomalies | grep -E -o "([0-9]{1,2}[/][A-Za-z]{3}[/][0-9]{4})"))
#Toutes les adresses IP
tableauIp=($(echo $lignesAnomalies | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | grep -v "51.79.53.246"))

#log apache2
for ((i = 0; i < $nombreLigneAnomalies; ++i)); do
echo "$LIGNE

Service: $nom
Anomalie: $anomalie
Date: ${tableauDates[$i]}
Adressse Ip: ${tableauIp[$i]}

" >> $surveillanceLog
done