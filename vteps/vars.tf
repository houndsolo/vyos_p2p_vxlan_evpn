locals {
  vxlan_mgmt_cidr = 16
  vxlan_mgmt_ip = "10.20.1.${var.host_node.id}"
  vxlan_mgmt_ip_sub = "${local.vxlan_mgmt_ip}/${local.vxlan_mgmt_cidr}"

  vtep_vm_id = "9700${var.host_node.id}"
  vtep_id = var.host_node.id - 10
  vtep_ids = [10, 12, 13, 14, 17]

  vm_id = local.vtep_id+700+10

  peer_node_ids = [for node in var.nodes : node.node_id if node.node_id != var.host_node.id ]

   # Convert IDs to numbers for calculations

  p2p_ids = [
    for peer_id in local.peer_node_ids : (
      var.host_node.id < peer_id ?
      var.host_node.id * 10 + (peer_id - 10) :
      peer_id * 10 + (var.host_node.id - 10)
    )
  ]
}

variable "vtep_count" {
  type = number
  default = 6
}

variable "host_node" {
  description = "Information about the host node."
  type = object({
    id   = number  # Assuming 'id' is a numeric value. Change to 'string' if it's alphanumeric.
    name = string
    host_node = string
  })
}

#KILL ME KILL ME KILL ME KILL ME
variable "nodes" {
  description = "full mesh peering info"
  type = list(object({
    hostname  = string
    host_node = string
    node_id   = number
  }))
}
