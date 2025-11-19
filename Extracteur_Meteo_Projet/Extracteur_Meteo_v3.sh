#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <Ville>"
    exit 1
fi

VILLE="$1"
FICHIER_BRUT="meteo_brute_${VILLE}.json"
FICHIER_SORTIE="meteo.txt"

curl -s "wttr.in/${VILLE}?format=j1" > "$FICHIER_BRUT"

if [ $? -ne 0 ]; then
    echo "Erreur lors de la récupération des données pour $VILLE."
    rm -f "$FICHIER_BRUT"
    exit 1
fi

LIGNE_TEMP_ACTUELLE=$(grep -m1 '"temp_C"' "$FICHIER_BRUT")
VALEUR_TEMP_ACTUELLE=$(echo "$LIGNE_TEMP_ACTUELLE" \
    | sed 's/.*"temp_C"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
TEMPERATURE_ACTUELLE="${VALEUR_TEMP_ACTUELLE}°C"

LIGNE_TEMP_DEMAIN=$(grep '"avgtempC"' "$FICHIER_BRUT" | sed -n '2p')
VALEUR_TEMP_DEMAIN=$(echo "$LIGNE_TEMP_DEMAIN" \
    | sed 's/.*"avgtempC"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
TEMPERATURE_DEMAIN="${VALEUR_TEMP_DEMAIN}°C"

DATE_FORMATTEE=$(date +%Y-%m-%d)
HEURE_FORMATTEE=$(date +%H:%M)

LIGNE_ENREGISTREMENT="${DATE_FORMATTEE} - ${HEURE_FORMATTEE} - ${VILLE} : ${TEMPERATURE_ACTUELLE} - ${TEMPERATURE_DEMAIN}"

#v1
echo "$LIGNE_ENREGISTREMENT" >> "$FICHIER_SORTIE"

#v3
FICHIER_HISTORIQUE="meteo_${DATE_FORMATTEE}.txt"
echo "$LIGNE_ENREGISTREMENT" >> "$FICHIER_HISTORIQUE"

rm -f "$FICHIER_BRUT"

echo "Météo enregistrée dans :"
echo " - $FICHIER_SORTIE"
echo " - $FICHIER_HISTORIQUE"
echo
echo "Ligne ajoutée : $LIGNE_ENREGISTREMENT"
