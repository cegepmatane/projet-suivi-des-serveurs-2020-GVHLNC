#!/bin/sh

moment(){
	date +"%Y-%m-%d_%Hh%Mm%Ss"
}

minute(){
	date +"%Y-%m-%d %Hh%Mm%S"
}

SEPARATEUR="-----------------------------------------"
SEPARATEURFIN="\n*************************************\n"
destination="/var/surveillance/log-passwd_$(moment).log"
fichier="/etc/passwd"
checksum="${fichier}.md5"

if [ -f $checksum ]; then
	if !(md5sum -c $checksum); then
echo "$SEPARATEUR
Détection d'un changement de signature
fichier concerné : $fichier
$SEPARATEUR
moment : $(minute)
md5 avant : $(cat $checksum | cut -d' ' -f1)
md5 après : $(md5sum $fichier | cut -d' ' -f1)
$SEPARATEURFIN" >> $destination
	md5sum $fichier > $checksum
	fi
else
	md5sum $fichier > $checksum
fi
