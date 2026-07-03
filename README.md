# BESTTIC - Infrastructure GitOps (Terraform + Ansible)

## Présentation générale

Ce projet implémente une infrastructure complète automatisée basée sur une approche **GitOps**, combinant :

- Terraform → Provisioning de l’infrastructure (Proxmox)
- Cloud-Init → Initialisation des machines
- Ansible → Configuration des systèmes et services

L’objectif est de fournir une infrastructure :

- reproductible
- automatisée
- standardisée
- versionnée
- évolutive

---

# Architecture globale

```

GitOps BESTTIC

│
├── terraform/        → Création des VM et LXC (Proxmox)
│   ├── modules/
│   ├── environments/
│   └── README.md
│
├── ansible/          → Configuration des serveurs
│   ├── playbooks/
│   ├── roles/
│   └── inventories/
│
├── cloud-init/       → Templates d’initialisation
│
└── docs/             → Documentation technique

```

---

# Architecture fonctionnelle

```

Terraform
↓
Création VM / LXC sur Proxmox
↓
Cloud-Init
↓
OS prêt + accès SSH
↓
Ansible
↓
Configuration complète des services
↓
Supervision (Zabbix)
↓
Interconnexion (WireGuard / VPN)
↓
Exploitation

```

---

# Composants de l’infrastructure

## 1. Infrastructure virtuelle (Terraform)

Terraform gère :

- création des VM
- création des conteneurs LXC
- configuration réseau (VLAN)
- allocation CPU / RAM / disque
- adressage IP statique
- templates Proxmox

### Environnements

| Environnement | Rôle |
|--------------|------|
| dev | tests et développement |
| prod | infrastructure réelle |

---

## 2. Configuration système (Ansible)

Ansible gère :

- installation des paquets
- configuration système Linux
- création utilisateur admin
- configuration réseau logique
- installation agents (Zabbix)
- déploiement des services métiers

---

# Déploiement complet de l’infrastructure

## Étape 1 - Provisioning Terraform

```bash
cd terraform/environments/dev
terraform init
terraform plan
terraform apply
```

👉 Résultat :
- machines créées dans Proxmox
- IP attribuées
- VLAN configurés
- accès SSH disponible

---

## Étape 2 - Configuration Ansible

```bash
cd ansible
ansible-playbook -i inventories/dev/hosts playbooks/site.yml
```

👉 Résultat :
- serveurs standardisés
- utilisateurs créés
- Zabbix installé
- services configurés

---

# Cas d’usage d’exploitation

## Cas 1 - Ajouter un nouveau serveur

### 1. Terraform

Ajouter un bloc VM :

```hcl
module "srv_new" {
  source = "../../modules/vm"
  name   = "Besttic-srv-new"
  ip     = "10.20.x.x"
}
```

### 2. Apply

```bash
terraform apply
```

### 3. Ansible

Ajouter dans l’inventaire :

```bash
srv_new
```

Puis :

```bash
ansible-playbook site.yml
```

---

## Cas 2 - Reconfiguration complète d’un serveur

```bash
ansible-playbook site.yml --limit srv_samba
```

👉 Réinitialise la configuration système

---

## Cas 3 - Déploiement d’un service spécifique

```bash
ansible-playbook deploy.yml --limit srv_nextcloud
```

---

## Cas 4 - Recréation complète d’un environnement

```bash
terraform destroy
terraform apply
ansible-playbook site.yml
```

---

# Services déployés

## Machines virtuelles

| Service | Rôle | VLAN |
|--------|------|------|
| Zabbix | supervision | 30 |
| VPN | WireGuard | 10 |
| Samba | stockage | 20 |
| Nextcloud | collaboration | 10 |
| VoIP | téléphonie | 10 |
| Calcul | HPC / IA | 20 |

---

## Conteneurs LXC

| Service | Rôle |
|--------|------|
| GitLab | CI/CD & code |
| Documentation | serveur doc |

---

# Sécurité et segmentation

- VLAN par fonction métier
- séparation DMZ / interne
- filtrage pfSense
- accès VPN site-à-site WireGuard
- supervision Zabbix centralisée

---

# Gestion du cycle de vie

## Ajout d’un service

1. Terraform (création VM)
2. Cloud-Init (initialisation)
3. Ansible (configuration)
4. Zabbix (monitoring)

---

## Modification d’un serveur

- uniquement via Terraform ou Ansible
- jamais en manuel sur la VM

---

## Suppression d’un serveur

```bash
terraform destroy
```

---

# Bonnes pratiques

✔ Infrastructure déclarative uniquement  
✔ Aucun changement manuel en production  
✔ Versionnement Git obligatoire  
✔ Test en dev avant production  
✔ Séparation Terraform / Ansible stricte  
✔ Documentation obligatoire pour chaque nouveau service  

---

# Dépannage

## Terraform

```bash
terraform plan
terraform validate
terraform refresh
```

---

## Ansible

```bash
ansible all -m ping
ansible-playbook -vvv
```

---

## Réseau

- vérifier VLAN Proxmox
- vérifier pfSense routes
- vérifier WireGuard tunnel
- vérifier DNS interne

---

# Supervision

Tous les serveurs sont supervisés via :

- Zabbix Server (10.20.30.150)
- Agents Zabbix (automatiquement installés)

---

# Objectif final du projet

Ce projet vise à construire une infrastructure :

- automatisée de bout en bout
- évolutive multi-sites
- sécurisée (VPN + VLAN)
- supervisée
- prête pour production

---

# Auteur

Projet réalisé dans le cadre d’un stage de fin d’études

Infrastructure :

- Proxmox VE
- Terraform
- Ansible
- WireGuard
- pfSense
- Zabbix
- GitOps
