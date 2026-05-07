module "web01" {
  source = "../../modules/vm"

  name        = "dev-web-01"
  vm_id       = 210
  template_id = 103

  cores  = 2
  memory = 2048

  bridge    = "vmbr0"
  datastore = "vm-storage"

  ip      = "192.168.1.101/24"
  gateway = "192.168.1.1"
}

module "db01" {
  source = "../../modules/vm"

  name        = "dev-db-01"
  vm_id       = 211
  template_id = 202

  cores  = 2
  memory = 4096

  bridge    = "vmbr0"
  datastore = "vm-storage"

  ip      = "192.168.1.102/24"
  gateway = "192.168.1.1"
}

module "calcul01" {
  source = "../../modules/vm"

  name        = "dev-calcul-01"
  vm_id       = 212
  template_id = 201

  cores  = 2
  memory = 8192

  bridge    = "vmbr0"
  datastore = "vm-storage"

  ip      = "192.168.1.103/24"
  gateway = "192.168.1.1"
}
