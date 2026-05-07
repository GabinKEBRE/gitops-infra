variable "node" {}
variable "vmid" {}
variable "name" {}
variable "ip" {}
variable "gateway" {}
variable "cores" {}
variable "memory" {}
variable "disk_size" {}
variable "storage" {}
variable "template" {}
variable "ssh_public_key" {
  description = "La clé publique SSH pour l'accès root"
  type        = string
}

variable "root_password" {
  description = "Le mot de passe de l'utilisateur root"
  type        = string
  sensitive   = true # Masque le mot de passe dans les logs
}
