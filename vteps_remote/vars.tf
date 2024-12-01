variable  "remote_peer_ip" {
  type = string
}
variable  "host_peer_ip" {
  type = string
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

