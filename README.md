# Infrastructure Terraform - BESTTIC

## Présentation

Ce dépôt permet le déploiement automatisé de l'infrastructure virtuelle de l'entreprise BESTTIC sur une plateforme Proxmox VE grâce à Terraform.

L'objectif est de garantir :

- un déploiement reproductible
- une infrastructure versionnée
- une gestion centralisée
- une standardisation des serveurs
- une évolution simplifiée de l'infrastructure

---

# Architecture

```
terraform/

│

├── modules/

│   ├── vm/

│   └── lxc/

│

├── environments/

│   ├── dev/

│   ├── recette/

│   └── production/

│

├── templates/

│

├── variables/

│

└── README.md

```

Le projet repose sur :

- Modules réutilisables
- Environnements indépendants
- Cloud-Init
- Provider Proxmox

---

# Architecture des environnements

Le dépôt est organisé en plusieurs environnements.

| Environnement | Description |
|--------------|-------------|
| dev | Développement |
| recette | Validation |
| production | Production |

Chaque environnement possède son propre :

- main.tf
- variables
- state Terraform

---

# Modules Terraform

Deux modules sont disponibles.

## Module VM

Permet le déploiement des machines virtuelles.

Fonctionnalités :

- création automatique
- Cloud-Init
- configuration réseau
- VLAN
- disque
- mémoire
- CPU
- GPU (si nécessaire)

Emplacement :

```
modules/vm
```

---

## Module LXC

Permet le déploiement automatique des conteneurs Proxmox.

Fonctionnalités :

- création automatique
- configuration réseau
- VLAN
- disque
- mémoire
- clé SSH
- mot de passe

Emplacement :

```
modules/lxc
```

---

# Machines virtuelles déployées

## Besttic-srv-zabbix

Fonction :

Serveur de supervision.

Services hébergés :

- Zabbix Server
- Base de données
- Agent

Réseau :

VLAN Administration

Adresse IP

```
10.20.30.150
```

Configuration

- 4 vCPU
- 8 Go RAM
- 40 Go disque

---

## Besttic-srv-vpn

Fonction

Serveur VPN.

Services

- WireGuard

Adresse

```
10.20.10.151
```

Configuration

- 2 vCPU
- 2 Go RAM

---

## Besttic-srv-samba

Fonction

Serveur de fichiers.

Services

- Samba

Adresse

```
10.20.20.152
```

Configuration

- 4 vCPU
- 8 Go RAM
- 100 Go disque

---

## Besttic-srv-nextcloud

Fonction

Cloud privé.

Services

- Apache
- PHP
- MariaDB
- Nextcloud

Adresse

```
10.20.10.153
```

Configuration

- Ubuntu 22.04
- 4 vCPU
- 8 Go RAM
- 60 Go disque

---

## Besttic-srv-voip

Fonction

Téléphonie IP.

Adresse

```
10.20.10.154
```

Configuration

- Debian
- 4 vCPU
- 8 Go RAM

---

## Besttic-srv-calcul

Fonction

Serveur HPC / IA.

Adresse

```
10.20.20.155
```

Configuration

- Rocky Linux
- 16 vCPU
- RTX4000
- 16 Go RAM
- 150 Go disque

---

# Conteneurs LXC

## Besttic-lxc01-doc

Fonction

Serveur documentaire.

Adresse

```
10.20.20.215
```

Configuration

- Ubuntu 24.04
- 2 vCPU
- 2 Go RAM

---

## Besttic-lxc02-gitlab

Fonction

Gestion des dépôts Git.

Adresse

```
10.20.20.210
```

Configuration

- Debian Turnkey GitLab
- 2 vCPU
- 4 Go RAM

---

# Plan d'adressage

| Equipement | Adresse |
|------------|----------|
| Zabbix | 10.20.30.150 |
| VPN | 10.20.10.151 |
| Samba | 10.20.20.152 |
| Nextcloud | 10.20.10.153 |
| VoIP | 10.20.10.154 |
| Calcul | 10.20.20.155 |
| Documentation | 10.20.20.215 |
| GitLab | 10.20.20.210 |

---

# Déploiement

Initialisation

```bash
terraform init
```

Validation

```bash
terraform validate
```

Visualisation

```bash
terraform plan
```

Déploiement

```bash
terraform apply
```

Suppression

```bash
terraform destroy
```

---

# Ajouter une nouvelle VM

Créer un nouveau bloc dans :

```
terraform/environments/dev/main.tf
```

Exemple

```hcl
module "srv_web" {

source="../../modules/vm"

...

}
```

Puis

```bash
terraform plan
terraform apply
```

---

# Ajouter un nouveau conteneur

Créer un nouveau module dans

```
lxc.tf
```

Puis

```bash
terraform apply
```

---

# Modifier une machine

Modifier uniquement :

- CPU
- RAM
- disque
- VLAN
- IP

Puis

```bash
terraform apply
```

Terraform appliquera uniquement les différences.

---

# Gestion des templates

Les templates doivent être présents dans Proxmox.

Exemple

```
101 Ubuntu 22.04

201 Debian 12

202 Rocky Linux 9
```

Toute modification des templates impactera les futurs déploiements.

---

# Cloud-Init

Chaque VM est configurée automatiquement :

- utilisateur
- mot de passe
- adresse IP
- passerelle
- DNS
- SSH

Aucune intervention manuelle n'est nécessaire après le déploiement.

---

# Exploitation

Après chaque déploiement vérifier :

□ VM créée

□ Adresse IP correcte

□ VLAN correct

□ SSH accessible

□ Cloud-Init terminé

□ Services démarrés

□ Sauvegarde Proxmox

□ Supervision Zabbix

---

# Bonnes pratiques

Ne jamais modifier une VM directement depuis Proxmox.

Toutes les modifications doivent être réalisées dans Terraform.

Ne jamais modifier le fichier terraform.tfstate manuellement.

Conserver les templates à jour.

Versionner chaque évolution dans Git.

Documenter chaque nouvelle VM.

---

# Dépannage

## VM absente

```
terraform state list
```

---

## Etat incohérent

```
terraform refresh
```

---

## Vérifier le plan

```
terraform plan
```

---

## Réimporter une VM

```
terraform import
```

---

# Auteur

Projet réalisé dans le cadre du stage de fin d'études

Entreprise : BESTTIC

Infrastructure automatisée :

- Proxmox VE
- Terraform
- Cloud-Init
- GitOps

