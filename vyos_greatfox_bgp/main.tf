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
    l2vpn_evpn = {}
    ipv4_unicast = {
      soft_reconfiguration = {inbound = true}
    }
  }
}

resource "vyos_protocols_bgp_address_family_l2vpn_evpn_vni" "vni_6" {
  depends_on = [vyos_protocols_bgp_address_family_l2vpn_evpn.l2vpn_evpn_config]
  identifier = { vni = 6 }
  #advertise_default_gw = true
  advertise_svi_ip     = true

}

resource "vyos_protocols_bgp_neighbor" "bgp_neighbors_border1" {
  depends_on = [vyos_protocols_bgp_peer_group.peer_group_p2p_vtep]
  identifier = { neighbor = var.border1_peer_ip }
  remote_as = var.border1_as
  peer_group = "p2p_vtep"
}

resource "vyos_protocols_bgp_neighbor" "bgp_neighbors_border2" {
  depends_on = [vyos_protocols_bgp_peer_group.peer_group_p2p_vtep]
  identifier = { neighbor = var.border2_peer_ip }
  remote_as = var.border2_as
  peer_group = "p2p_vtep"
}

