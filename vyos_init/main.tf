locals {
  dum0_network = "10.240.255.${var.host_node.id}/32"
  bgp_system_as = 700 + var.host_node.id
}
resource "vyos_system" "host_parameters" {
  #domain_name = "lylat.space"
  #domain_search = ["lylat.space"]
  host_name = var.host_node.name
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
  address = [
    local.dum0_network
  ]
  mtu = "1400"
}


#p2p peering

resource "vyos_interfaces_ethernet" "vtep_p2p_links" {
  for_each = {
    for peer in local.p2p_cfg :
    peer.hostname => peer
  }
  identifier = { ethernet = "eth${tostring(each.value.eth_id)}" }
  description = "p2p link to ${each.value.hostname}"
  address = [each.value.host_ip]
  lifecycle {
    ignore_changes = [
      hw_id
    ]
  }
}

resource "vyos_interfaces_ethernet_vif" "link_b1" {
  count = var.host_node.name == "vtep-fi-border" ? 1 : 0
  identifier = {
    ethernet = "eth9"
    vif = 2191
  }
  description = "link to b1"
  address = ["10.240.28.1/31"]
}

resource "vyos_interfaces_ethernet_vif" "link_b2" {
  count = var.host_node.name == "vtep-ti-border" ? 1 : 0
  identifier = {
    ethernet = "eth9"
    vif = 2192
  }
  description = "link to b2"
  address = ["10.240.29.1/31"]
}
