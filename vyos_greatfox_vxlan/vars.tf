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
