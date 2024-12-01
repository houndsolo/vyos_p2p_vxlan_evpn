locals {
  vxlan_mtu = 1350
  disable_arp_filter = false
  disable_forwarding = false
  enable_arp_accept = false
  enable_arp_announce = false
  enable_directed_broadcast = true
  enable_proxy_arp = false
  proxy_arp_pvlan = false

  vxlan_external = true
  vxlan_neighbor_suppress = false
  vxlan_nolearning = true
  vxlan_vni_filter = false

  bgp_l2vpn_flooding_disable = false
  bgp_l2vpn_her = false
}

module "p2p_vtep" {
  for_each = { for node in var.nodes : node.node_id => node }
  source = "./vteps"
  host_node = {
    id = each.value.node_id
    name = each.value.hostname
    host_node = each.value.host_node
  }
  nodes= var.nodes
}




module "vtep_greatfox" {
  source = "./vteps_greatfox"
  providers = { proxmox = proxmox.greatfox }
  host_node = {
    id = 20
    name = "vtep-greatfox"
  }
  pve_node = "greatfox"
  peer_vlan = 600
  border1_host_ip = "10.240.28.0/31"
  border1_peer_ip = "10.240.28.1"
  border1_as = 718

  border2_host_ip = "10.240.29.0/31"
  border2_peer_ip = "10.240.29.1"
  border2_as = 719
}

module "vyos_init" {
  depends_on = [module.p2p_vtep]
  for_each = { for node in var.nodes : node.node_id => node }
  source = "./vyos_init"
  providers = { vyos = vyos.p2p_nodes[each.key] }
  host_node = {
    id = each.value.node_id
    name = each.value.hostname
    host_node = each.value.host_node
  }
  nodes= var.nodes
}

module "vyos_bgp" {
  depends_on = [module.vyos_init]
  for_each = { for node in var.nodes : node.node_id => node }
  source = "./vyos_bgp"
  providers = { vyos = vyos.p2p_nodes[each.key] }
  host_node = {
    id = each.value.node_id
    name = each.value.hostname
    host_node = each.value.host_node
  }
  nodes= var.nodes
  bgp_l2vpn_her = local.bgp_l2vpn_her
  bgp_l2vpn_flooding_disable = local.bgp_l2vpn_flooding_disable
}

module "vyos_vxlan" {
  depends_on = [module.vyos_init]
  for_each = { for node in var.nodes : node.node_id => node }
  source = "./vyos_vxlan"
  providers = { vyos = vyos.p2p_nodes[each.key] }
  host_node = {
    id = each.value.node_id
    name = each.value.hostname
    host_node = each.value.host_node
  }
  nodes= var.nodes
  vxlan_mtu = local.vxlan_mtu
  disable_arp_filter = local.disable_arp_filter
  disable_forwarding = local.disable_forwarding
  enable_arp_accept = local.enable_arp_accept
  enable_arp_announce = local.enable_arp_announce
  enable_directed_broadcast = local.enable_directed_broadcast
  enable_proxy_arp = local.enable_proxy_arp
  proxy_arp_pvlan = local.proxy_arp_pvlan
  vxlan_external = local.vxlan_external
  vxlan_neighbor_suppress = local.vxlan_neighbor_suppress
  vxlan_nolearning = local.vxlan_nolearning
  vxlan_vni_filter = local.vxlan_vni_filter
}

module "vtep_greatfox_vyos_init" {
  depends_on = [module.vtep_greatfox]
  source = "./vyos_greatfox_init"
  providers = { vyos = vyos.greatfox }
  host_node = {
    id = 20
    name = "vtep-greatfox"
  }
  pve_node = "greatfox"
  peer_vlan = 600
  border1_host_ip = "10.240.28.0/31"
  border1_peer_ip = "10.240.28.1"
  border1_as = 718

  border2_host_ip = "10.240.29.0/31"
  border2_peer_ip = "10.240.29.1"
  border2_as = 719
}

module "vtep_greatfox_vyos_bgp" {
  depends_on = [module.vtep_greatfox_vyos_init]
  source = "./vyos_greatfox_bgp"
  providers = { vyos = vyos.greatfox }
  host_node = {
    id = 20
    name = "vtep-greatfox"
  }
  pve_node = "greatfox"
  peer_vlan = 600
  border1_host_ip = "10.240.28.0/31"
  border1_peer_ip = "10.240.28.1"
  border1_as = 718

  border2_host_ip = "10.240.29.0/31"
  border2_peer_ip = "10.240.29.1"
  border2_as = 719
  bgp_l2vpn_her = local.bgp_l2vpn_her
  bgp_l2vpn_flooding_disable = local.bgp_l2vpn_flooding_disable
}

module "vtep_greatfox_vyos_vxlan" {
  depends_on = [module.vtep_greatfox_vyos_bgp]
  source = "./vyos_greatfox_vxlan"
  providers = { vyos = vyos.greatfox }
  host_node = {
    id = 20
    name = "vtep-greatfox"
  }
  pve_node = "greatfox"
  peer_vlan = 600
  border1_host_ip = "10.240.28.0/31"
  border1_peer_ip = "10.240.28.1"
  border1_as = 718

  border2_host_ip = "10.240.29.0/31"
  border2_peer_ip = "10.240.29.1"
  border2_as = 719

  vxlan_mtu = local.vxlan_mtu
  disable_arp_filter = local.disable_arp_filter
  disable_forwarding = local.disable_forwarding
  enable_arp_accept = local.enable_arp_accept
  enable_arp_announce = local.enable_arp_announce
  enable_directed_broadcast = local.enable_directed_broadcast
  enable_proxy_arp = local.enable_proxy_arp
  proxy_arp_pvlan = local.proxy_arp_pvlan
  vxlan_external = local.vxlan_external
  vxlan_neighbor_suppress = local.vxlan_neighbor_suppress
  vxlan_nolearning = local.vxlan_nolearning
  vxlan_vni_filter = local.vxlan_vni_filter
}

#module "border_vtep" {
#  source = "./vteps_remote"
#  host_node = {
#    id = 80
#    name = "vtep-remote"
#  }
#  pve_node = "fichina"
#  peer_vlan = 3080
#  host_peer_ip = "10.240.80.0/31"
#  remote_peer_ip = "10.240.80.1"
#}

#module "vtep_border_vyos_init" {
#  depends_on = [module.border_vtep]
#  source = "./vyos_border_init"
#  providers = { vyos = vyos.border }
#  host_node = {
#    id = 80
#    name = "vtep-border"
#  }
#  pve_node = "fichina"
#  peer_vlan = 3080
#  host_peer_ip = "10.240.80.0/31"
#  remote_peer_ip = "10.240.80.1"
#  haystack_peer_ip = "10.69.69.253/24"
#  haystack_remote_peer_ip = "10.69.69.1"
#}
#
#module "vtep_border_vyos_bgp" {
#  depends_on = [module.vtep_border_vyos_init]
#  source = "./vyos_border_bgp"
#  providers = { vyos = vyos.border }
#  host_node = {
#    id = 80
#    name = "vtep-border"
#  }
#  pve_node = "fichina"
#  peer_vlan = 3080
#  host_peer_ip = "10.240.80.0/31"
#  remote_peer_ip = "10.240.80.1"
#  haystack_peer_ip = "10.69.69.253/24"
#  haystack_remote_peer_ip = "10.69.69.1"
#  bgp_l2vpn_her = local.bgp_l2vpn_her
#  bgp_l2vpn_flooding_disable = local.bgp_l2vpn_flooding_disable
#}
#
#
#module "vtep_border_vyos_vxlan" {
#  depends_on = [module.vtep_border_vyos_bgp]
#  source = "./vyos_border_vxlan"
#  providers = { vyos = vyos.border }
#  host_node = {
#    id = 80
#    name = "vtep-border"
#  }
#  pve_node = "fichina"
#  peer_vlan = 3080
#  host_peer_ip = "10.240.80.0/31"
#  remote_peer_ip = "10.240.80.1"
#  haystack_peer_ip = "10.240.255.252/32"
#  haystack_remote_peer_ip = "10.7"
#
#  vxlan_mtu = local.vxlan_mtu
#  disable_arp_filter = local.disable_arp_filter
#  disable_forwarding = local.disable_forwarding
#  enable_arp_accept = local.enable_arp_accept
#  enable_arp_announce = local.enable_arp_announce
#  enable_directed_broadcast = local.enable_directed_broadcast
#  enable_proxy_arp = local.enable_proxy_arp
#  proxy_arp_pvlan = local.proxy_arp_pvlan
#  vxlan_external = local.vxlan_external
#  vxlan_neighbor_suppress = local.vxlan_neighbor_suppress
#  vxlan_nolearning = local.vxlan_nolearning
#  vxlan_vni_filter = local.vxlan_vni_filter
#}
#
