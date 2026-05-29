###############################################
# ENVIRONNEMENT DEV - INFRASTRUCTURE DE BASE
#              ENTREPRISE BESTTIC
###############################################

# ZABBIX - Supervision (Administration - VLAN 30)
module "srv_zabbix" {
  source = "../../modules/vm"

  name        = "Besttic-srv-zabbix"
  vm_id       = 500
  template_id = 201 # debian-12-template

  cores  = 4
  memory = 8192

  bridge    = "vmbr0"
  vlan_tag  = 30
  datastore = "vm-storage"

  ip      = "10.20.30.150/24"
  gateway = "10.20.30.1"
}

# VPN - WireGuard (IoT Nodes) (DMZ - VLAN 10)
module "srv_vpn" {
  source = "../../modules/vm"

  name        = "Besttic-srv-vpn"
  vm_id       = 501
  template_id = 201 # debian-12-template

  cores  = 2
  memory = 2048

  bridge    = "vmbr0"
  vlan_tag  = 10
  datastore = "vm-storage"

  ip      = "10.20.10.151/24"
  gateway = "10.20.10.1"
}

# SAMBA - Serveur de fichiers (Interne - VLAN 20)
module "srv_samba" {
  source = "../../modules/vm"

  name        = "Besttic-srv-samba"
  vm_id       = 502
  template_id = 201 # debian-12-template

  cores  = 4
  memory = 8192

  bridge    = "vmbr0"
  vlan_tag  = 20
  datastore = "vm-storage"

  ip      = "10.20.20.152/24"
  gateway = "10.20.20.1"
}

# NEXTCLOUD - Ubuntu 22.04 LTS (DMZ - VLAN 10)
module "srv_nextcloud" {
  source = "../../modules/vm"

  name        = "Besttic-srv-nextcloud"
  vm_id       = 503
  template_id = 101 # ubuntu-22-template

  cores  = 4
  memory = 8192

  bridge    = "vmbr0"
  vlan_tag  = 10
  datastore = "vm-storage"

  ip      = "10.20.10.153/24"
  gateway = "10.20.10.1"
}

# NEXTCLOUD DATABASE / VOIP (DMZ - VLAN 20)
module "srv_nextcloud_db" {
  source = "../../modules/vm"

  name        = "Besttic-srv-voip"
  vm_id       = 504
  template_id = 201 # debian-12-template

  cores  = 4
  memory = 8192

  bridge    = "vmbr0"
  vlan_tag  = 10
  datastore = "vm-storage"

  ip      = "10.20.10.154/24"
  gateway = "10.20.10.1"
}

# SERVEUR DE CALCUL - HPC / Batch / ML (Interne - VLAN 20)
module "srv_calcul" {
  source = "../../modules/vm"

  name        = "Besttic-srv-calcul"
  vm_id       = 505
  template_id = 202 # rocky-9-template

  cores  = 16
  memory = 16384

  bridge    = "vmbr0"
  vlan_tag  = 20
  datastore = "vm-storage"

  ip      = "10.20.20.155/24"
  gateway = "10.20.20.1"
}
