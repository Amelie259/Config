#!/bin/bash

# V2.1 Configuration de la ville par défaut
VILLE_PAR_DEFAUT="Toulouse"
FICHIER_SORTIE="meteo.txt"

# V3.1 Gestion de l'historique
DATE_ARCHIVAGE=$(date +%Y%m%d)
FICHIER_HISTORIQUE="meteo_${DATE_ARCHIVAGE}.txt"

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

# Variante 1 : Récupération d'informations supplémentaires

# Vitesse du vent
LIGNE_VENT=$(grep -m1 '"windspeedKmph"' "$FICHIER_BRUT")
VALEUR_VENT=$(echo "$LIGNE_VENT" \
    | sed 's/.*"windspeedKmph"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
VENT="${VALEUR_VENT} km/h"

# Taux d'humidité
LIGNE_HUMIDITE=$(grep -m1 '"humidity"' "$FICHIER_BRUT")
VALEUR_HUMIDITE=$(echo "$LIGNE_HUMIDITE" \
    | sed 's/.*"humidity"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
HUMIDITE="${VALEUR_HUMIDITE}%"

# Visibilité
LIGNE_VISIBILITE=$(grep -m1 '"visibility"' "$FICHIER_BRUT")
VALEUR_VISIBILITE=$(echo "$LIGNE_VISIBILITE" \
    | sed 's/.*"visibility"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
VISIBILITE="${VALEUR_VISIBILITE} km"

# V1.3 Formatage de la date et heure et la ligne formatée 
DATE_FORMATTEE=$(date +%Y-%m-%d)
HEURE_FORMATTEE=$(date +%H:%M)

# Ligne formatée avec informations supplémentaires
LIGNE_ENREGISTREMENT="${DATE_FORMATTEE} - ${HEURE_FORMATTEE} - ${VILLE} : ${TEMPERATURE_ACTUELLE} - ${TEMPERATURE_DEMAIN} - Vent: ${VENT} - Humidité: ${HUMIDITE} - Visibilité: ${VISIBILITE}"

# V1.4 Enregistrement dans le fichier de sortie principal
echo "$LIGNE_ENREGISTREMENT" >> "$FICHIER_SORTIE"

# V3.1 Enregistrement dans le fichier d'historique quotidien
echo "$LIGNE_ENREGISTREMENT" >> "$FICHIER_HISTORIQUE"

# V1.1 Nettoyage du fichier temporaire
rm -f "$FICHIER_BRUT"

# V1.3 Affichage du résultat formaté
echo "Météo pour ${VILLE} enregistrée dans ${FICHIER_SORTIE}."
echo "Données archivées dans: ${FICHIER_HISTORIQUE}"
echo "Ligne ajoutée : $LIGNE_ENREGISTREMENT"

