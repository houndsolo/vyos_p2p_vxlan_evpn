locals {
  dum0_network = "10.240.255.${var.host_node.id}/32"
  bgp_system_as = 700 + var.host_node.id
}
resource "vyos_system" "host_parameters" {
  domain_name = "lylat.space"
  domain_search = ["lylat.space"]
  host_name = "vtep-greatfox"
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
  description = "source interface for vxlan"
  address = [
    local.dum0_network
  ]
  mtu = "1400"
}

resource "vyos_interfaces_ethernet" "link_to_border1" {
  identifier = { ethernet = "eth1" }
  description = "link_to_border1"
  address = [var.border1_host_ip]
  lifecycle {
    ignore_changes = [
      hw_id
    ]
  }
}

resource "vyos_interfaces_ethernet" "link_to_border2" {
  identifier = { ethernet = "eth2" }
  description = "link_to_border2"
  address = [var.border2_host_ip]
  lifecycle {
    ignore_changes = [
      hw_id
    ]
  }
}

resource "vyos_interfaces_ethernet" "link_to_vms" {
  identifier = { ethernet = "eth3" }
  description = "link_to_vms"
  lifecycle {
    ignore_changes = [
      hw_id
    ]
  }
}
