locals {
  dum0_network = "10.240.255.${var.host_node.id}/32"
  bgp_system_as = 700 + var.host_node.id
}
resource "vyos_system" "host_parameters" {
  domain_name = "lylat.space"
  domain_search = ["lylat.space"]
  host_name = "vtep-remote"
}

#resource "vyos_system_ip_multipath" "set_multipath" {
#  ignore_unreachable_nexthops = true
#  layer4_hashing = true
#}

resource "vyos_system_ipv6" "disable_ipv6" {
  disable_forwarding = true
}

resource "vyos_interfaces_dummy" "dummy_interface" {
  identifier = {dummy = "dum0"}
  description = "vxlan source"
  address = [
    local.dum0_network
  ]
  mtu = "1400"
}

resource "vyos_interfaces_ethernet" "link_to_fichina" {
  identifier = { ethernet = "eth1" }
  description = "link_to_vmbr1"
  lifecycle {
    ignore_changes = [
      hw_id
    ]
  }
}

resource "vyos_interfaces_ethernet" "link_to_haystack" {
  identifier = { ethernet = "eth2" }
  description = "link_to_haystack"
  address = [var.haystack_peer_ip]
  lifecycle {
    ignore_changes = [
      hw_id
    ]
  }
}

resource "vyos_interfaces_ethernet_vif" "link_to_n100" {
  depends_on = [resource.vyos_interfaces_ethernet.link_to_fichina]
  identifier = {
    ethernet = "eth1"
    vif = 1080
  }
  description = "link to remote"
  address = ["10.240.255.250/31"]
}

resource "vyos_interfaces_ethernet_vif" "link_to_p2p" {
  depends_on = [resource.vyos_interfaces_ethernet_vif.link_to_n100]
  identifier = {
    ethernet = "eth2"
    vif = 1081
  }
  description = "link to remote"
  address = [var.host_peer_ip]
}

