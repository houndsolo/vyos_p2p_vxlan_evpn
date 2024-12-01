variable "haystack_peer_ip" {
  type = string
}
variable "haystack_remote_peer_ip" {
  type = string
}
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
variable "vtep_count" {
  type = number
  default = 6
}

variable "host_node" {
  description = "Information about the host node."
  type = object({
    id   = number  # Assuming 'id' is a numeric value. Change to 'string' if it's alphanumeric.
    name = string
  })
}
variable "vxlan_mtu" {
  type = number
}
variable "disable_arp_filter" {
  type = bool
}
variable "disable_forwarding" {
  type = bool
}
variable "enable_arp_accept" {
  type = bool
}
variable "enable_arp_announce" {
  type = bool
}
variable "enable_directed_broadcast" {
  type = bool
}
variable "enable_proxy_arp" {
  type = bool
}
variable "proxy_arp_pvlan" {
  type = bool
}
variable "vxlan_external" {
  type = bool
}
variable "vxlan_neighbor_suppress" {
  type = bool
}
variable "vxlan_nolearning" {
  type = bool
}
variable "vxlan_vni_filter" {
  type = bool
}
