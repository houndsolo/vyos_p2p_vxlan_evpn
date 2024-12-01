variable "border1_host_ip" {
  description = "Host IP address for Border 1 in CIDR notation"
  type        = string
  default     = "10.240.28.0/31"
}

variable "border1_peer_ip" {
  description = "Peer IP address for Border 1"
  type        = string
  default     = "10.240.28.1"
}

variable "border1_as" {
  description = "Autonomous System (AS) number for Border 1"
  type        = number
  default     = 718
}

variable "border2_host_ip" {
  description = "Host IP address for Border 2 in CIDR notation"
  type        = string
  default     = "10.240.29.0/31"
}

variable "border2_peer_ip" {
  description = "Peer IP address for Border 2"
  type        = string
  default     = "10.240.29.1"
}

variable "border2_as" {
  description = "Autonomous System (AS) number for Border 2"
  type        = number
  default     = 719
}
variable  "pve_node" {
  type = string
}
variable  "peer_vlan" {
  type = number
}
locals {
  mgmt_cidr = 16
  mgmt_ip = "10.20.1.${var.host_node.id}"
  mgmt_ip_sub = "${local.mgmt_ip}/${local.mgmt_cidr}"

  vm_id = 700 + var.host_node.id

  host_id  = var.host_node.id
}


variable "host_node" {
  description = "Information about the host node."
  type = object({
    id   = number  # Assuming 'id' is a numeric value. Change to 'string' if it's alphanumeric.
    name = string
  })
}

