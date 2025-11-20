# Config

Notre projet consiste à développer un programme en langage Shell qui récupère automatiquement les données météorologiques d'une ville. Pour utiliser le script,
il suffit d'exécuter la commande ./Extracteur_Meteo.sh suivie du nom d'une ville, par exemple ./Extracteur_Meteo.sh Paris.
 
Si aucun argument n'est fourni, le script utilise automatiquement Toulouse comme ville par défaut. 
Concrètement, le script se connecte au service wttr.in, extrait la température actuelle et celle prévue pour le lendemain, 
puis enregistre ces informations de manière organisée dans un fichier texte.
Pour automatiser l'exécution périodique du script, nous avons configuré une tâche cron comme expliqué ci-dessous. 

À travers ce projet, nous apprenons à travailler en équipe avec Git, à gérer les différentes versions du programme et à résoudre les problèmes 
techniques ensemble. Chaque nouvelle version ajoute des fonctionnalités pour rendre le script plus pratique et performant.




# Explication de la Configuration de la tache cron:
Pour planifier mon script météo avec cron, j'ai d'abord dû m'assurer d'utiliser un environnement Linux puisque cron ne fonctionne pas directement sous Windows. 
J'ai donc installé WSL avec Ubuntu qui me permet d'exécuter des commandes Linux.

J'ai commencé par installer cron avec la commande sudo apt install cron, puis j'ai démarré le service avec sudo service cron start. 
Ensuite, je me suis connecté à Ubuntu et je me suis rendu dans le dossier de mon projet. Pour être sûr d'utiliser le bon chemin, 
j'ai utilisé la commande pwd qui m'a affiché le chemin exact.

Une fois dans le bon dossier, j'ai ouvert le planificateur de tâches avec crontab -e et j'ai ajouté ma ligne de configuration. 
Ma tâche cron est programmée pour s'exécuter toutes les minutes : elle se place d'abord dans le dossier de mon projet, 
puis lance mon script météo pour Toulouse en mode debug, et enfin enregistre tous les résultats dans un fichier log pour que je puisse vérifier si tout fonctionne.

" 0 * * * * cd /mnt/c/Users/pc/Config/Extracteur_Meteo_Projet && /bin/bash -x ./Extracteur_Meteo.sh Toulouse >> /tmp/cron_debug.log 2>&1 "

Pour terminer, j'ai utilisé sudo service cron status pour m'assurer que le service était bien activé et qu'il fonctionnait 
correctement en arrière-plan, ready à exécuter mon script automatiquement selon la planification définie.
