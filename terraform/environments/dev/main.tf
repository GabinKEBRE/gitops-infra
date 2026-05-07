###############################################
# ENVIRONNEMENT DEV - INFRASTRUCTURE DE BASE
#              ENTREPRISE BESTTIC
###############################################

# ZABBIX - Supervision
module "srv_zabbix" {
  source = "../../modules/vm"

  name        = "dev-srv-zabbix"
  vm_id       = 500
  template_id = 201 # debian-12-template

  cores  = 4
  memory = 8192

  bridge    = "vmbr0"
  datastore = "vm-storage"

  ip      = "192.168.1.150/24"
  gateway = "192.168.1.1"
}

# VPN - WireGuard (IoT Nodes)
module "srv_vpn" {
  source = "../../modules/vm"

  name        = "dev-srv-vpn"
  vm_id       = 501
  template_id = 201 # debian-12-template

  cores  = 2
  memory = 2048

  bridge    = "vmbr0"
  datastore = "vm-storage"

  ip      = "192.168.1.151/24"
  gateway = "192.168.1.1"
}

# SAMBA - Serveur de fichiers
module "srv_samba" {
  source = "../../modules/vm"

  name        = "dev-srv-samba"
  vm_id       = 502
  template_id = 201 # debian-12-template

  cores  = 4
  memory = 8192

  bridge    = "vmbr0"
  datastore = "vm-storage"

  ip      = "192.168.1.152/24"
  gateway = "192.168.1.1"
}

# NEXTCLOUD - Ubuntu 22.04 LTS
module "srv_nextcloud" {
  source = "../../modules/vm"

  name        = "dev-srv-nextcloud"
  vm_id       = 503
  template_id = 101 # ubuntu-22-template

  cores  = 4
  memory = 8192

  bridge    = "vmbr0"
  datastore = "vm-storage"

  ip      = "192.168.1.153/24"
  gateway = "192.168.1.1"
}

# NEXTCLOUD DATABASE - MariaDB/PostgreSQL
module "srv_nextcloud_db" {
  source = "../../modules/vm"

  name        = "dev-srv-nextcloud-db"
  vm_id       = 504
  template_id = 201 # debian-12-template

  cores  = 4
  memory = 8192

  bridge    = "vmbr0"
  datastore = "vm-storage"

  ip      = "192.168.1.154/24"
  gateway = "192.168.1.1"
}

# SERVEUR DE CALCUL - HPC / Batch / ML
module "srv_calcul" {
  source = "../../modules/vm"

  name        = "dev-srv-calcul"
  vm_id       = 505
  template_id = 202 # rocky-9-template

  cores  = 16
  memory = 16384

  bridge    = "vmbr0"
  datastore = "vm-storage"

  ip      = "192.168.1.155/24"
  gateway = "192.168.1.1"
}
