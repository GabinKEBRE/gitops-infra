resource "proxmox_virtual_environment_container" "lxc" {

  node_name = var.node
  vm_id     = var.vmid

  started = true

  initialization {
    hostname = var.name

    user_account {
      keys     = [var.ssh_public_key]
      password = var.root_password
          }
    ip_config {
      ipv4 {
        address = var.ip
        gateway = var.gateway
      }
    }
  }

  cpu {
    cores = var.cores
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = var.storage
    size         = var.disk_size
  }

  network_interface {
    name = "eth0"
    bridge = "vmbr0"
  }

  operating_system {
    template_file_id = var.template
    type             = "ubuntu"
  }
}
