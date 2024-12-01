locals {
  dum0_network = "10.240.255.${var.host_node.id}/32"
  bgp_system_as = 700 + var.host_node.id
}

resource "vyos_protocols_bgp" "enable_bgp" {
  system_as = local.bgp_system_as
}

resource "vyos_protocols_bgp_address_family_ipv4_unicast_maximum_paths" "bgp_multipath" {
  depends_on = [vyos_protocols_bgp.enable_bgp]
  ebgp = 1
  ibgp = 1
}

resource "vyos_protocols_bgp_address_family_ipv4_unicast_network" "bgp_advertise_dum0" {
  # would rather do ospf on interface[, but can only for ipv6??] -> redistribute into bgp
  depends_on = [vyos_protocols_bgp.enable_bgp]
  identifier = {
    network = local.dum0_network
  }
}

resource "vyos_protocols_bgp_address_family_ipv4_unicast_network" "vtep_p2p_links" {
  depends_on = [vyos_protocols_bgp_address_family_ipv4_unicast_network.bgp_advertise_dum0]
  for_each = {
    for peer in local.p2p_cfg :
    peer.hostname => peer
  }
  identifier = { network = each.value.host_ip_network }
}

resource "vyos_protocols_bgp_address_family_ipv4_unicast_network" "bgp_advertise_b1" {
  count = var.host_node.name == "vtep-fi-border" ? 1 : 0
  depends_on = [vyos_protocols_bgp_address_family_ipv4_unicast_network.vtep_p2p_links]
  identifier = {
    network = "10.240.28.0/31"
  }
}

resource "vyos_protocols_bgp_address_family_ipv4_unicast_network" "bgp_advertise_b2" {
  count = var.host_node.name == "vtep-ti-border" ? 1 : 0
  depends_on = [vyos_protocols_bgp_address_family_ipv4_unicast_network.bgp_advertise_b1]
  identifier = {
    network = "10.240.29.0/31"
  }
}

resource "vyos_protocols_bgp_parameters_bestpath_as_path" "bgp_ebgp_multipath" {
  depends_on = [vyos_protocols_bgp.enable_bgp]
  # ignore different as path numbers , same length
  multipath_relax = false
}

resource "vyos_protocols_bgp_address_family_l2vpn_evpn" "l2vpn_evpn_config" {
  depends_on = [vyos_protocols_bgp.enable_bgp]
  advertise_all_vni = true
  advertise_svi_ip = false
  rt_auto_derive = true
}

resource "vyos_protocols_bgp_address_family_l2vpn_evpn_flooding" "l2vpn_evpn_flooding" {
  depends_on = [vyos_protocols_bgp_address_family_l2vpn_evpn.l2vpn_evpn_config]
  disable = var.bgp_l2vpn_flooding_disable
  head_end_replication = var.bgp_l2vpn_her
}


resource "vyos_protocols_bgp_peer_group" "peer_group_p2p_vtep" {
  depends_on = [vyos_protocols_bgp.enable_bgp]
  identifier = {peer_group = "p2p_vtep"}
  ebgp_multihop = 4
  address_family = {
    l2vpn_evpn = {
      #soft_reconfiguration = {inbound = true}
      #  nexthop_self = {}
    }
    ipv4_unicast = {
      soft_reconfiguration = {inbound = true}
      #nexthop_self = {}
    }
  }
}

resource "vyos_protocols_bgp_address_family_l2vpn_evpn_vni" "vni_9" {
  depends_on = [vyos_protocols_bgp_address_family_l2vpn_evpn.l2vpn_evpn_config]
  identifier = { vni = 6 }
  #advertise_default_gw = true
  advertise_svi_ip     = true

}

resource "vyos_protocols_bgp_neighbor" "bgp_neighbors" {
  depends_on = [vyos_protocols_bgp_peer_group.peer_group_p2p_vtep]
  for_each = {
    for peer in local.p2p_cfg :
    peer.hostname => peer
  }
  identifier = { neighbor = each.value.peer_ip }
  remote_as = each.value.peer_as
  peer_group = "p2p_vtep"
}

resource "vyos_protocols_bgp_neighbor" "greatfox_neighbor_b1" {
  count = var.host_node.name == "vtep-fi-border" ? 1 : 0
  depends_on = [vyos_protocols_bgp_neighbor.bgp_neighbors]
  identifier = { neighbor = "10.240.28.0" }
  remote_as = 720
  peer_group = "p2p_vtep"
}

resource "vyos_protocols_bgp_neighbor" "greatfox_neighbor_b2" {
  count = var.host_node.name == "vtep-ti-border" ? 1 : 0
  depends_on = [vyos_protocols_bgp_neighbor.greatfox_neighbor_b1]
  identifier = { neighbor = "10.240.29.0" }
  remote_as = 720
  peer_group = "p2p_vtep"
}

