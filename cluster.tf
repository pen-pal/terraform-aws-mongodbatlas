####################3###################################
### MONGODB ATLAS CLUSTER IN THE PROJECT : SHARDED CLUSTER
####################3###################################
resource "mongodbatlas_cluster" "sharded" {
  count                       = local.sharding == false && local.free_tier == false && var.create && var.cluster_type != "REPLICASET" ? 1 : 0
  project_id                  = mongodbatlas_project.project[0].id
  name                        = var.cluster_name
  provider_name               = local.provider_name
  backing_provider_name       = local.backing_provider_name
  provider_region_name        = var.atlas_region
  provider_instance_size_name = var.instance_type
  mongo_db_major_version      = var.mongodb_major_ver
  cluster_type                = local.free_tier ? "REPLICASET" : local.cluster_type
  cloud_backup                = local.free_tier ? false : var.cloud_backup
  pit_enabled                 = local.free_tier ? false : var.cloud_backup
  disk_size_gb                = local.free_tier ? null : var.disk_size_gb
  provider_volume_type        = local.free_tier ? "" : var.volume_type
  provider_disk_iops          = local.sharding && var.volume_type == "STANDARD" ? null : var.provider_disk_iops
  num_shards                  = local.sharding ? 1 : var.num_shards
  #for auto_scaling
  #storage scaling
  auto_scaling_disk_gb_enabled = local.free_tier ? false : var.auto_scaling_disk_gb_enabled
  #cluster tier scaling
  auto_scaling_compute_enabled                    = local.free_tier ? false : var.auto_scaling_compute_enabled
  auto_scaling_compute_scale_down_enabled         = local.free_tier || var.auto_scaling_compute_enabled == false ? false : var.auto_scaling_compute_scale_down_enabled
  provider_auto_scaling_compute_min_instance_size = local.free_tier ? "" : var.provider_auto_scaling_compute_min_instance_size
  provider_auto_scaling_compute_max_instance_size = local.free_tier ? "" : var.provider_auto_scaling_compute_max_instance_size
  #encryption
  encryption_at_rest_provider = local.free_tier ? "NONE" : var.encryption_at_rest_provider

  dynamic "replication_specs" {
    for_each = var.cluster_type != "REPLICASET" && var.replication_specs_sharded != null ? var.replication_specs_sharded : []
    content {
      num_shards = replication_specs.value.num_shards
      zone_name  = replication_specs.value.zone_name
      regions_config {
        region_name     = replication_specs.value.region_name
        electable_nodes = replication_specs.value.electable_nodes
        priority        = replication_specs.value.priority
        read_only_nodes = replication_specs.value.read_only_nodes
      }
    }
  }

  dynamic "labels" {
    for_each = var.labels
    content {
      key   = labels.key
      value = labels.value
    }
  }

  depends_on = [
    mongodbatlas_project.project,
    mongodbatlas_encryption_at_rest.encryption,
    mongodbatlas_cloud_provider_access_setup.setup_only,
    mongodbatlas_cloud_provider_access_authorization.auth_role
  ]
}


####################3###################################
### MONGODB ATLAS CLUSTER IN THE PROJECT : REPLICASET ? FREE TIER
####################3###################################
resource "mongodbatlas_cluster" "replicaset" {
  count                       = local.sharding || (var.create && var.cluster_type == "REPLICASET") || local.free_tier ? 1 : 0
  project_id                  = mongodbatlas_project.project[0].id
  name                        = var.cluster_name
  provider_name               = local.provider_name
  backing_provider_name       = local.backing_provider_name
  provider_region_name        = var.atlas_region
  provider_instance_size_name = var.instance_type
  mongo_db_major_version      = var.mongodb_major_ver
  cluster_type                = local.free_tier ? "REPLICASET" : local.cluster_type
  cloud_backup                = local.free_tier ? false : var.cloud_backup
  pit_enabled                 = local.free_tier ? false : var.cloud_backup
  disk_size_gb                = local.free_tier ? null : var.disk_size_gb
  provider_volume_type        = local.free_tier ? "" : var.volume_type
  provider_disk_iops          = local.sharding && var.volume_type == "STANDARD" ? null : var.provider_disk_iops
  num_shards                  = local.sharding ? 1 : var.num_shards
  #for auto_scaling
  #storage scaling
  auto_scaling_disk_gb_enabled = local.free_tier ? false : var.auto_scaling_disk_gb_enabled
  #cluster tier scaling
  auto_scaling_compute_enabled                    = local.free_tier ? false : var.auto_scaling_compute_enabled
  auto_scaling_compute_scale_down_enabled         = local.free_tier || var.auto_scaling_compute_enabled == false ? false : var.auto_scaling_compute_scale_down_enabled
  provider_auto_scaling_compute_min_instance_size = local.free_tier ? "" : var.provider_auto_scaling_compute_min_instance_size
  provider_auto_scaling_compute_max_instance_size = local.free_tier ? "" : var.provider_auto_scaling_compute_max_instance_size
  #encryption
  encryption_at_rest_provider = local.free_tier ? "NONE" : var.encryption_at_rest_provider

  replication_specs {
    num_shards = var.replication_specs != null ? var.num_shards_replicaset : var.num_shards
    dynamic "regions_config" {
      for_each = var.replication_specs != null ? var.replication_specs : local.replication_specs
      content {
        region_name     = regions_config.value.region_name
        electable_nodes = regions_config.value.electable_nodes
        priority        = regions_config.value.priority
        read_only_nodes = regions_config.value.read_only_nodes
      }
    }
  }

  dynamic "labels" {
    for_each = var.labels
    content {
      key   = labels.key
      value = labels.value
    }
  }

  depends_on = [
    mongodbatlas_project.project,
    mongodbatlas_encryption_at_rest.encryption,
    mongodbatlas_cloud_provider_access_setup.setup_only,
    mongodbatlas_cloud_provider_access_authorization.auth_role
  ]
}
