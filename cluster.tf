####################3###################################
### MONGODB ATLAS CLUSTER IN THE PROJECT
####################3###################################

resource "mongodbatlas_cluster" "cluster" {
  project_id                  = mongodbatlas_project.project.id
  name                        = var.cluster_name
  provider_name               = var.instance_type == "M0" ? "TENANT" : var.cloud_provider
  backing_provider_name       = var.instance_type == "M0" ? "AWS" : ""
  provider_region_name        = var.region
  provider_instance_size_name = var.instance_type
  mongo_db_major_version      = var.mongodb_major_ver
  cluster_type                = var.cluster_type
  num_shards                  = var.instance_type == "M0" ? 1 : var.num_shards
  cloud_backup                = var.cloud_backup
  pit_enabled                 = var.pit_enabled
  disk_size_gb                = var.instance_type == "M0" ? null : var.disk_size_gb
  provider_volume_type        = var.instance_type == "M0" ? "" : var.volume_type
  provider_disk_iops          = var.volume_type == "STANDARD" ? null : var.provider_disk_iops

  #for auto_scaling
  #storage scaling
  auto_scaling_disk_gb_enabled = var.instance_type == "M0" ? false : var.auto_scaling_disk_gb_enabled

  #cluster tier scaling
  auto_scaling_compute_enabled                    = var.instance_type == "M0" ? false : var.auto_scaling_compute_enabled
  auto_scaling_compute_scale_down_enabled         = var.instance_type == "M0" || var.auto_scaling_compute_enabled == false ? false : var.auto_scaling_compute_scale_down_enabled
  provider_auto_scaling_compute_min_instance_size = var.instance_type == "M0" || var.auto_scaling_compute_enabled == false ? "" : var.provider_auto_scaling_compute_min_instance_size
  provider_auto_scaling_compute_max_instance_size = var.instance_type == "M0" || var.auto_scaling_compute_enabled == false ? "" : var.provider_auto_scaling_compute_max_instance_size

  #encryption
  encryption_at_rest_provider = var.encryption_at_rest_provider
}
