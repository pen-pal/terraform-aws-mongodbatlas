#The module from mongodb itself is limited to AWS only for now.
locals {
  cloud_provider = "AWS"
  db_users_flat = merge([
    for lists, users in var.db_users :
    {
      for user, data in users :
      "${lists}-${user}" => {
        username = user
        cluster  = data
      }
    }
  ]...) # please do NOT remove the dots

  free_tier             = substr(var.instance_type, 1, length(var.instance_type)) < substr("M10", 1, length("M10")) || var.cloud_provider == "TENANT"
  provider_name         = local.free_tier ? "TENANT" : var.cloud_provider
  backing_provider_name = local.free_tier || local.provider_name == "TENANT" ? var.backing_provider_name : ""
  cluster_type          = var.cluster_type == "REPLICASET" || (substr(var.instance_type, 1, length(var.instance_type)) < substr("M30", 1, length("M30"))) ? "REPLICASET" : var.cluster_type
  sharding              = substr(var.instance_type, 1, length(var.instance_type)) < substr("M30", 1, length("M30"))

  replication_specs = [
    {
      electable_nodes = var.electable_nodes
      priority        = var.priority
      read_only_nodes = var.read_only_nodes
      region_name     = var.atlas_region
    }
  ]

}
