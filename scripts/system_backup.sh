#!/bin/bash
# scripts/system_backup.sh

# Définition des variables 
SRC="/var/www/html"
BACKUP_DIR="/home/khouloud/ln-labs/cron"
DEST="$BACKUP_DIR/backup-$(date +%F).tar.gz"

echo "=== [LN-Labs] Démarrage de la sauvegarde automatisée ==="

# 1. Vérifier si le répertoire source existe
if [ -d "$SRC" ]; then
    # 2. Compresser le dossier source en archive .tar.gz
    tar -czf "$DEST" "$SRC"
    
    # 3. Gérer le code de sortie (Exit Code) de la commande précédente
    if [ $? -eq 0 ]; then
        echo "✅ Sauvegarde réussie avec succès !"
        echo "Fichier créé : $DEST"
        exit 0 # Succès
    else
        echo "❌ Erreur : Échec lors de la compression de l'archive."
        exit 1 # Échec
    fi
else
    echo "❌ Erreur : Le répertoire source $SRC n'existe pas."
    exit 1 # Échec
fi
