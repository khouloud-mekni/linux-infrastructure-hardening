#!/bin/bash
# scripts/setup_users.sh

echo "=== [LN-Labs] Configuration des utilisateurs et permissions ==="

# 1. Créer le groupe de l'équipe DevOps 
sudo groupadd -f devops

# 2. Créer l'utilisateur 'alice' avec son dossier personnel et son shell par défaut
if ! id "alice" &>/dev/null; then
    sudo useradd -m -g devops -s /bin/bash alice
    # Définir un mot de passe par défaut pour alice
    echo "alice:DevopsPassword2026!" | sudo chpasswd
    echo "✅ Utilisateur 'alice' créé avec succès."
else
    echo "ℹ️ L'utilisateur 'alice' existe déjà."
fi

# 3. Changer le propriétaire du dossier web de Nginx (/var/www/html)
# Le propriétaire devient 'alice' et le groupe devient 'devops'
sudo chown -R alice:devops /var/www/html

# 4. Appliquer les permissions strictes
sudo chmod -R 750 /var/www/html

echo "=== Configuration terminée avec succès ! ==="
