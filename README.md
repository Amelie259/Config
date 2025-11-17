# Config
Explication de la Configuration de la tache cron:
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

