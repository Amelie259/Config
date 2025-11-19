#!/bin/bash

# V2.1 Configuration de la ville par défaut
VILLE_PAR_DEFAUT="Toulouse"
FICHIER_SORTIE="meteo.txt"


if [ -z "$1" ]; then
    VILLE="$VILLE_PAR_DEFAUT"
    echo "Aucune ville fournie. Utilisation de la ville par défaut : ${VILLE}"
else
    VILLE="$1"
fi

# V1.1 Récupération des données météo brutes via curl
FICHIER_BRUT="meteo_brute_${VILLE}.json"
curl -s "wttr.in/${VILLE}?format=j1" > "$FICHIER_BRUT"

if [ $? -ne 0 ]; then
    echo "Erreur lors de la récupération des données pour $VILLE."
    rm -f "$FICHIER_BRUT"
    exit 1
fi

# V1.2 Extraction de la température actuelle et la temp moyen pour demain
LIGNE_TEMP_ACTUELLE=$(grep -m1 '"temp_C"' "$FICHIER_BRUT")
VALEUR_TEMP_ACTUELLE=$(echo "$LIGNE_TEMP_ACTUELLE" \
    | sed 's/.*"temp_C"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
TEMPERATURE_ACTUELLE="${VALEUR_TEMP_ACTUELLE}°C"


LIGNE_TEMP_DEMAIN=$(grep '"avgtempC"' "$FICHIER_BRUT" | sed -n '2p')
VALEUR_TEMP_DEMAIN=$(echo "$LIGNE_TEMP_DEMAIN" \
    | sed 's/.*"avgtempC"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
TEMPERATURE_DEMAIN="${VALEUR_TEMP_DEMAIN}°C"

# V1.3 Formatage de la date et heure et la ligne formate 
DATE_FORMATTEE=$(date +%Y-%m-%d)
HEURE_FORMATTEE=$(date +%H:%M)


LIGNE_ENREGISTREMENT="${DATE_FORMATTEE} - ${HEURE_FORMATTEE} - ${VILLE} : ${TEMPERATURE_ACTUELLE} - ${TEMPERATURE_DEMAIN}"

# V1.4 Enregistrement dans le fichier de sortie
echo "$LIGNE_ENREGISTREMENT" >> "$FICHIER_SORTIE"

# V1.1 Nettoyage du fichier temporaire
rm -f "$FICHIER_BRUT"

# V1.3 Affichage du résultat formaté
echo "Météo pour ${VILLE} enregistrée dans ${FICHIER_SORTIE}."
echo "Ligne ajoutée : $LIGNE_ENREGISTREMENT"
#V2.2 et V2.3 déjà fait sur nos machines et la Configuration est expliqué dans le README
