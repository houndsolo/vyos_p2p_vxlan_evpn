locals {
  peer_nodes = [for node in var.nodes : node if node.node_id != var.host_node.id ]
  peer_node_ids = [for node in var.nodes : node.node_id if node.node_id != var.host_node.id ]
  p2p_cfg = [
    for idx, peer in zipmap(range(length(local.peer_nodes)), local.peer_nodes) :{
      eth_id = idx + 1
      hostname = peer.hostname
      peer_as = 700 + peer.node_id
      dum0_peer_address = "10.240.255.${peer.node_id}"
      peer_id = (
        var.host_node.id < peer.node_id ?
        var.host_node.id * 10 + (peer.node_id - 10) :
        peer.node_id * 10 + (var.host_node.id - 10)
      )
      peer_ip  =  (
        var.host_node.id < peer.node_id ?
        "10.240.${var.host_node.id * 10 + (peer.node_id - 10)}.1" :
        "10.240.${peer.node_id * 10 + (var.host_node.id - 10)}.0"
      )
      host_ip_network  =  (
        var.host_node.id < peer.node_id ?
        "10.240.${var.host_node.id * 10 + (peer.node_id - 10)}.0/31" :
        "10.240.${peer.node_id * 10 + (var.host_node.id - 10)}.0/31"
      )
      host_ip  =  (
        var.host_node.id < peer.node_id ?
        "10.240.${var.host_node.id * 10 + (peer.node_id - 10)}.0/31" :
        "10.240.${peer.node_id * 10 + (var.host_node.id - 10)}.1/31"
      )
      host_ip_32  =  (
        var.host_node.id < peer.node_id ?
        "10.240.${var.host_node.id * 10 + (peer.node_id - 10)}.0/32" :
        "10.240.${peer.node_id * 10 + (var.host_node.id - 10)}.1/32"
      )
    }
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
variable "bgp_l2vpn_her" {
  type = bool
}
variable "bgp_l2vpn_flooding_disable" {
  type = bool
}
