#!/bin/bash
# scripts/secure_server.sh

echo "=== [LN-Labs] Configuration et Durcissement du Pare-feu (UFW) ==="

# 1. Réinitialiser les règles par défaut : 
# On rejette toutes les connexions entrantes, on autorise les connexions sortantes
sudo ufw default deny incoming
sudo ufw default allow outgoing

# 2. Autoriser uniquement les ports essentiels de notre architecture
sudo ufw allow 80/tcp   # Port HTTP pour notre serveur Nginx
sudo ufw allow 22/tcp   # Port SSH pour la maintenance à distance sécurisée

# 3. Activer le pare-feu (le 'echo y' permet de valider automatiquement la confirmation)
echo "y" | sudo ufw enable

# 4. Afficher le statut final pour contrôle
echo "Statut actuel du pare-feu :"
sudo ufw status verbose

echo "=== [LN-Labs] Pare-feu configuré et actif ! ==="
