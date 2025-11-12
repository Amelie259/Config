#!/bin/bash

#Vérification si un argument à été fourni
if [ -z "$1" ];then
	echo "Usage: $0<Ville>"
	exit 1
fi

VILLE="$1"
FICHIER_BRUT="meteo_brute_$<{VILLE}.txt"
FICHIER_SORTIE="meteo.txt"

#Récupération des données brutes de wttr.in
#L'option -t permet de ne pas utiliser le format HTML/CSS pour une extraction plus facile
#l'option -n désactive l affichage du soleil et de la lune
#L'option -q désactive les descriptions de méteo (comme Ligth Rain)
#L'option -0 force l affichage d une seule ligne d information par section (actuelle et demain)

curl -s  "wttr.in/${VILLE}?format=%t\n%t" >"$FICHIER_BRUT"

#vérification si curl à réussi
if [ $? -ne 0 ];then
	echo "Erreur lors de la récupération des données pour $VILLE."
	rm -f "$FICHIER_BRUT" #Supprime le fichier brut si il y a une erreur
	exit 1
fi
# La récupération de wttr.in est structurée sur deux lignes :


TEMPERATURE_ACTUELLE=$(head -n 1 "$FICHIER_BRUT" | tr -d '[:space:]')

TEMPERATURE_DEMAIN=$(tail -n 1 "$FICHIER_BRUT" | tr -d '[:space:]')



# Obtenir la date et l'heure actuelles

DATE_FORMATTEE=$(date +%Y-%m-%d)

HEURE_FORMATTEE=$(date +%H:%M)

