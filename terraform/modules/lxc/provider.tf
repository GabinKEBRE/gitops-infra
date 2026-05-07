terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.105"
    }
  }
}
provider "proxmox" {
  endpoint = "https://192.168.1.47:8006/api2/json"

  api_token = "automation@pve!terraform=360ff66a-5ef1-4cee-90a1-671591663a57"

  insecure = true
}
