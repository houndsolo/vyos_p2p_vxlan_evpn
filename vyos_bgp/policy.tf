  #depends_on = [vyos_protocols_bgp_neighbor.greatfox_neighbor_b2]
resource "vyos_policy_prefix_list" "PL_p2p_local_32" {
  identifier = { prefix_list = "local_p2p_32" }
}

resource "vyos_policy_prefix_list_rule" "PL_local_p2p_rules" {
  depends_on = [resource.vyos_policy_prefix_list.PL_p2p_local_32]
  for_each = {
    for idx, peer in local.p2p_cfg :
    idx => peer
  }

  identifier = {
    prefix_list = "local_p2p_32"
    rule        = each.key + 1
  }

  action = "permit"
  prefix = each.value.host_ip_32

  # Add any additional configuration here if needed
}

