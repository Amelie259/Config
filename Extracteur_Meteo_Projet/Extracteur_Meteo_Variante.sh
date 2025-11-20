#!/bin/bash

# Ville par défaut
VILLE_PAR_DEFAUT="Toulouse"
VILLE=${1:-$VILLE_PAR_DEFAUT}

# Message si aucune ville fournie
if [ -z "$1" ]; then
    echo "Aucune ville fournie. Utilisation de la ville par défaut : ${VILLE}"
fi

# Fichiers de sortie
FICHIER_BRUT="meteo_brute_${VILLE}.json"
FICHIER_SORTIE="meteo.txt"
FICHIER_SORTIE_JSON="meteo.json"

# Récupération des données météo
curl -s "wttr.in/${VILLE}?format=j1" > "$FICHIER_BRUT"

if [ $? -ne 0 ] || [ ! -s "$FICHIER_BRUT" ]; then
    echo "Erreur lors de la récupération des données pour $VILLE."
    rm -f "$FICHIER_BRUT"
    exit 1
fi

# Extraction des informations
TEMP_ACTUELLE=$(grep -m1 '"temp_C"' "$FICHIER_BRUT" | sed 's/.*"temp_C":[ ]*"\([^"]*\)".*/\1/')
TEMP_DEMAIN=$(grep '"avgtempC"' "$FICHIER_BRUT" | sed -n '2p' | sed 's/.*"avgtempC":[ ]*"\([^"]*\)".*/\1/')
VENT=$(grep -m1 '"windspeedKmph"' "$FICHIER_BRUT" | sed 's/.*"windspeedKmph":[ ]*"\([^"]*\)".*/\1/')
HUMIDITE=$(grep -m1 '"humidity"' "$FICHIER_BRUT" | sed 's/.*"humidity":[ ]*"\([^"]*\)".*/\1/')
VISIBILITE=$(grep -m1 '"visibility"' "$FICHIER_BRUT" | sed 's/.*"visibility":[ ]*"\([^"]*\)".*/\1/')

DATE_FORMATTEE=$(date +%Y-%m-%d)
HEURE_FORMATTEE=$(date +%H:%M)

# Format texte
LIGNE_TEXTE="${DATE_FORMATTEE} - ${HEURE_FORMATTEE} - ${VILLE} : ${TEMP_ACTUELLE} - ${TEMP_DEMAIN} - Vent: ${VENT} - Humidité: ${HUMIDITE} - Visibilité: ${VISIBILITE}"

# Format JSON
JSON_CONTENT=$(cat <<EOF
{
    "date": "$DATE_FORMATTEE",
    "heure": "$HEURE_FORMATTEE",
    "ville": "$VILLE",
    "temperature": "${TEMP_ACTUELLE}°C",
    "prevision": "${TEMP_DEMAIN}°C",
    "vent": "${VENT} km/h",
    "humidite": "${HUMIDITE}%",
    "visibilite": "${VISIBILITE} km"
}
EOF
)

# Texte
echo "$LIGNE_TEXTE" >> "$FICHIER_SORTIE"
echo "$LIGNE_TEXTE" >> "meteo_${DATE_FORMATTEE}.txt"

# JSON
echo "$JSON_CONTENT" >> "$FICHIER_SORTIE_JSON"
echo "$JSON_CONTENT" >> "meteo_${DATE_FORMATTEE}.json"
# Confirmation
echo "Ligne ajoutée : $LIGNE_TEXTE"
echo "Données enregistrées en texte et JSON."
echo "Fichier général texte : $FICHIER_SORTIE"
echo "Fichier journalier texte : meteo_${DATE_FORMATTEE}.txt"
echo "Fichier général JSON : $FICHIER_SORTIE_JSON"
echo "Fichier journalier JSON : meteo_${DATE_FORMATTEE}.json"

# Nettoyage
rm -f "$FICHIER_BRUT"

