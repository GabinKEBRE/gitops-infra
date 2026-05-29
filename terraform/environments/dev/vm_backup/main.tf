resource "proxmox_virtual_environment_vm" "vm" {

  name      = var.name
  node_name = "pve"
  vm_id     = var.vm_id

  clone {
    vm_id = var.template_id
  }

  cpu {
    cores = var.cores
    type  = "host"
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = var.datastore
    interface    = "scsi0"
    size         = 20
  }

  network_device {
    bridge = var.bridge
    model  = "virtio"
  }

  initialization {

    datastore_id = var.datastore

    ip_config {
      ipv4 {
        address = var.ip
        gateway = var.gateway
      }
    }

    user_account {
      username = "ubuntu"
      password = "LabPassword123"
      keys     = [file("/root/.ssh/id_ed25519.pub")]
    }
  }

  agent {
    enabled = true
  }

  on_boot = true
 
  startup {
    order    = 1
    up_delay = 60
 }
}
