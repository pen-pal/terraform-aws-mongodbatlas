####################3###################################
### MONGODB ATLAS CLUSTER IN THE PROJECT
####################3###################################
resource "mongodbatlas_cluster" "cluster" {
  project_id                  = mongodbatlas_project.project.id
  name                        = var.cluster_name
  provider_name               = (substr(var.instance_type, 1, length(var.instance_type)) < substr("M10", 1, length("M10"))) ? "TENANT" : var.cloud_provider
  backing_provider_name       = (substr(var.instance_type, 1, length(var.instance_type)) < substr("M10", 1, length("M10"))) || var.cloud_provider == "TENANT" ? var.backing_provider_name : ""
  provider_region_name        = var.region
  provider_instance_size_name = var.instance_type
  mongo_db_major_version      = var.mongodb_major_ver
  cluster_type                = (substr(var.instance_type, 1, length(var.instance_type)) < substr("M30", 1, length("M30"))) ? "REPLICASET" : var.cluster_type
  cloud_backup                = var.cloud_backup
  pit_enabled                 = var.pit_enabled
  disk_size_gb                = (substr(var.instance_type, 1, length(var.instance_type)) < substr("M10", 1, length("M10"))) ? null : var.disk_size_gb
  provider_volume_type        = (substr(var.instance_type, 1, length(var.instance_type)) < substr("M10", 1, length("M10"))) ? "" : var.volume_type
  provider_disk_iops          = var.volume_type == "STANDARD" ? null : var.provider_disk_iops
  num_shards                  = var.cluster_type != "REPLICASET" || (substr(var.instance_type, 1, length(var.instance_type)) < substr("M30", 1, length("M30"))) ? 1 : var.num_shards
  #for auto_scaling
  #storage scaling
  auto_scaling_disk_gb_enabled = (substr(var.instance_type, 1, length(var.instance_type)) < substr("M10", 1, length("M10"))) || var.cloud_provider == "TENANT" ? false : var.auto_scaling_disk_gb_enabled

  #cluster tier scaling
  auto_scaling_compute_enabled                    = (substr(var.instance_type, 1, length(var.instance_type)) < substr("M10", 1, length("M10"))) || var.cloud_provider == "TENANT" ? false : var.auto_scaling_compute_enabled
  auto_scaling_compute_scale_down_enabled         = (substr(var.instance_type, 1, length(var.instance_type)) < substr("M10", 1, length("M10"))) || var.cloud_provider == "TENANT" || var.auto_scaling_compute_enabled == false ? false : var.auto_scaling_compute_scale_down_enabled
  provider_auto_scaling_compute_min_instance_size = (substr(var.instance_type, 1, length(var.instance_type)) < substr("M10", 1, length("M10"))) || var.cloud_provider == "TENANT" || var.auto_scaling_compute_enabled == false ? "" : var.provider_auto_scaling_compute_min_instance_size
  provider_auto_scaling_compute_max_instance_size = (substr(var.instance_type, 1, length(var.instance_type)) < substr("M10", 1, length("M10"))) || var.cloud_provider == "TENANT" || var.auto_scaling_compute_enabled == false ? "" : var.provider_auto_scaling_compute_max_instance_size

  #encryption
  encryption_at_rest_provider = var.encryption_at_rest_provider

  dynamic "replication_specs" {
    for_each = var.cluster_type != "REPLICASET" && var.replication_specs != null ? var.replication_specs : []
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

  #replication_specs {
  #  num_shards = var.cluster_type == "REPLICASET" && var.replication_specs != null ? var.num_shards_replicaset : null
  #  dynamic "regions_config" {
  #    for_each = var.cluster_type == "REPLICASET" && var.replication_specs != null ? var.replication_specs : []
  #    content {
  #      region_name     = regions_config.value.region_name
  #      electable_nodes = regions_config.value.electable_nodes
  #      priority        = regions_config.value.priority
  #      read_only_nodes = regions_config.value.read_only_nodes
  #    }
  #  }
  #}

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
