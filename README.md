# Pipeline GitOps d'Automatisation - Terraform & Ansible

Ce dépôt centralise l'approche Infrastructure as Code (IaC) et la gestion de configuration de notre infrastructure. Il permet d'industrialiser, de sécuriser et de rendre reproductible le cycle de vie complet de nos ressources : du provisionnement brut des machines virtuelles (VMs) jusqu'au déploiement et à la mise en conformité des applicatifs conteneurisés.

## 🏗️ Philosophie et Workflow GitOps
[ Code (Git) ] ──► [ Terraform ] ──► Provisionnement des VMs & Réseaux
│
▼ (Génération de l'inventaire)
[ Code (Git) ] ──► [  Ansible  ] ──► Durcissement OS, Docker & Conteneurs

L'architecture de ce dépôt repose sur une séparation stricte des responsabilités entre le provisionnement de l'infrastructure et sa configuration :
1. **Terraform (Orchestrateur d'Infrastructure) :** Communique avec les APIs des hyperviseurs ou fournisseurs cloud pour concevoir la topologie réseau, les clés SSH, et provisionner les instances de VMs.
2. **Ansible (Gestionnaire de Configuration) :** Prend le relais une fois les machines accessibles en SSH pour appliquer les politiques de sécurité, installer les runtimes (Docker) et orchestrer les conteneurs applicatifs.

---

## 🎯 Cas d'Usage Principaux

### Cas 1 : Déploiement à chaud d'un nœud d'infrastructure d'entreprise
* **Besoin :** Instancier une nouvelle VM dédiée à un service d'équipe, configurer son pare-feu réseau, installer Docker, et déployer une pile de services isolés.
* **Résolution :** Exécution du bloc Terraform cible, injection automatique de l'IP dans l'inventaire dynamique Ansible, puis exécution du playbook de configuration de base de l'entreprise.

### Cas 2 : Audit de conformité et remédiation du "Configuration Drift"
* **Besoin :** S'assurer qu'aucune modification manuelle n'a altéré la configuration des conteneurs ou les règles de sécurité des OS sur le parc.
* **Résolution :** Lancement périodique d'Ansible en mode de vérification (`--check`) pour détecter les écarts et réappliquer l'état de référence défini dans le dépôt Git.

---

## 💻 Commandes Réelles d'Exploitation

### 1. Phase Terraform : Provisionnement des VMs

Toutes les commandes doivent être exécutées depuis le répertoire `./terraform`.

```bash
# Initialiser le répertoire (téléchargement des providers et initialisation du backend)
terraform init

# Valider la syntaxe et la cohérence des fichiers de configuration
terraform validate

# Générer et examiner le plan d'exécution (simulation des ressources créées/modifiées)
terraform plan -out=tfplan.binary

# Appliquer le plan pour provisionner réellement les VMs sur l'infrastructure
terraform apply "tfplan.binary"

# (Optionnel) Détruire l'intégralité des ressources provisionnées par ce bloc
# terraform destroy -auto-approve
2. Phase Ansible : Configuration et Déploiement de Conteneurs
Toutes les commandes doivent être exécutées depuis le répertoire ./ansible.
# Télécharger les rôles et collections indispensables (ex: community.docker)
ansible-galaxy collection install -r requirements.yml

# Tester la connectivité SSH initiale avec toutes les machines de l'inventaire
ansible all -i inventory.ini -m ping

# Exécuter le playbook principal pour configurer l'OS, installer Docker et lancer les conteneurs
ansible-playbook -i inventory.ini site.yml

# Exécuter uniquement les tâches liées au déploiement des conteneurs Docker (via les Tags)
ansible-playbook -i inventory.ini site.yml --tags "docker,apps"

# Lancer une vérification à blanc (dry-run) pour identifier les modifications sans les appliquer
ansible-playbook -i inventory.ini site.yml --check
