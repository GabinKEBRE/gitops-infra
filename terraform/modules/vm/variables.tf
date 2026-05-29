variable "name" {
  type = string
}

variable "vm_id" {
  type = number
}

variable "template_id" {
  type = number
}

variable "cores" {
  type = number
}

variable "memory" {
  type = number
}

variable "bridge" {
  type = string
}

variable "vlan_tag" {
  type        = number
  description = "Tag VLAN pour Proxmox (ex: 10 ou 20)"
  default     = null
}

variable "ip" {
  type        = string
  description = "IP avec CIDR (ex: 10.20.20.150/24) ou 'dhcp'"
}

variable "gateway" {
  type    = string
  default = null
}

variable "datastore" {
  type = string
}
