#!/bin/bash

VILLE_PAR_DEFAUT="Toulouse"

if [ -z "$1" ]; then
	VILLE="$VILLE_PAR_DEFAUT"
	echo"Aucune ville fournie. Utilisation de la ville par défaut : ${VILLE}"
else
	VILLE="$1"
fi

if [ -z "$1" ]; then
    echo "Usage: $0 <Ville>"
    exit 1
fi

VILLE="$1"
FICHIER_BRUT="meteo_brute_${VILLE}.txt"
FICHIER_SORTIE="meteo.txt"

curl -s "wttr.in/${VILLE}?format=%t\n%t" > "$FICHIER_BRUT"

if [ $? -ne 0 ]; then
    echo "Erreur lors de la récupération des données pour $VILLE."
    rm -f "$FICHIER_BRUT"
    exit 1
fi

TEMPERATURE_ACTUELLE=$(head -n 1 "$FICHIER_BRUT" | tr -d '[:space:]')

TEMPERATURE_DEMAIN=$(tail -n 1 "$FICHIER_BRUT" | tr -d '[:space:]')

DATE_FORMATTEE=$(date +%Y-%m-%d)
HEURE_FORMATTEE=$(date +%H:%M)


LIGNE_ENREGISTREMENT="${DATE_FORMATTEE} - ${HEURE_FORMATTEE} - ${VILLE} : ${TEMPERATURE_ACTUELLE} - ${TEMPERATURE_DEMAIN}"

echo "$LIGNE_ENREGISTREMENT" >> "$FICHIER_SORTIE"


rm -f "$FICHIER_BRUT"

echo "Météo pour ${VILLE} enregistrée dans ${FICHIER_SORTIE}."
echo "Ligne ajoutée : $LIGNE_ENREGISTREMENT"

