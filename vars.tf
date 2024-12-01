variable "nodes" {
  description = "List of network nodes with their details."
  type = list(object({
    hostname  = string
    host_node = string
    node_id   = number
  }))
  default = [
    {
      hostname  = "vtep-fichina"
      host_node = "fichina"
      node_id   = 10
    },
    {
      hostname  = "vtep-macbeth"
      host_node = "macbeth"
      node_id   = 12
    },
    {
      hostname  = "vtep-titania"
      host_node = "titania"
      node_id   = 13
    },
    {
      hostname  = "vtep-zoness"
      host_node = "zoness"
      node_id   = 14
    },
    {
      hostname  = "vtep-venom"
      host_node = "venom"
      node_id   = 17
    },
    {
      hostname  = "vtep-fi-border"
      host_node = "fichina"
      node_id   = 18
    },
    {
      hostname  = "vtep-ti-border"
      host_node = "titania"
      node_id   = 19
    },
  ]
}

