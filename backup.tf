resource "mongodbatlas_cloud_backup_schedule" "hourly" {
  count = var.create && local.free_tier == false && var.hourly_backup_enabled ? 1 : 0

  project_id   = mongodbatlas_project.project[0].id
  cluster_name = var.cluster_type == "REPLICASET" || local.free_tier || local.sharding ? mongodbatlas_cluster.replicaset[0].name : mongodbatlas_cluster.sharded[0].name

  reference_hour_of_day    = var.hourly_reference_hour_of_day != null ? var.hourly_reference_hour_of_day : var.reference_hour_of_day
  reference_minute_of_hour = var.hourly_reference_minute_of_hour != null ? var.hourly_reference_minute_of_hour : var.reference_minute_of_hour
  restore_window_days      = var.hourly_restore_window_days != null ? var.hourly_restore_window_days : var.restore_window_days

  // This will now add the desired policy items to the existing mongodbatlas_cloud_backup_schedule resource

  policy_item_hourly {
    frequency_interval = var.hourly_frequency_interval
    retention_unit     = var.hourly_retention_unit
    retention_value    = var.hourly_retention_value
  }
}

resource "mongodbatlas_cloud_backup_schedule" "daily" {
  count        = var.create && local.free_tier == false && var.daily_backup_enabled ? 1 : 0
  project_id   = mongodbatlas_project.project[0].id
  cluster_name = var.cluster_type == "REPLICASET" || local.free_tier || local.sharding ? mongodbatlas_cluster.replicaset[0].name : mongodbatlas_cluster.sharded[0].name

  reference_hour_of_day    = var.daily_reference_hour_of_day != null ? var.daily_reference_hour_of_day : var.reference_hour_of_day
  reference_minute_of_hour = var.daily_reference_minute_of_hour != null ? var.daily_reference_minute_of_hour : var.reference_minute_of_hour
  restore_window_days      = var.daily_restore_window_days != null ? var.daily_restore_window_days : var.restore_window_days

  // This will now add the desired policy items to the existing mongodbatlas_cloud_backup_schedule resource

  policy_item_daily {
    frequency_interval = var.daily_frequency_interval
    retention_unit     = var.daily_retention_unit
    retention_value    = var.daily_retention_value
  }
}
resource "mongodbatlas_cloud_backup_schedule" "weekly" {
  count        = var.create && local.free_tier == false && var.weekly_backup_enabled ? 1 : 0
  project_id   = mongodbatlas_project.project[0].id
  cluster_name = var.cluster_type == "REPLICASET" || local.free_tier || local.sharding ? mongodbatlas_cluster.replicaset[0].name : mongodbatlas_cluster.sharded[0].name

  reference_hour_of_day    = var.weekly_reference_hour_of_day != null ? var.weekly_reference_hour_of_day : var.reference_hour_of_day
  reference_minute_of_hour = var.weekly_reference_minute_of_hour != null ? var.weekly_reference_minute_of_hour : var.reference_minute_of_hour
  restore_window_days      = var.weekly_restore_window_days != null ? var.weekly_restore_window_days : var.restore_window_days

  // This will now add the desired policy items to the existing mongodbatlas_cloud_backup_schedule resource

  policy_item_weekly {
    frequency_interval = var.weekly_frequency_interval
    retention_unit     = var.weekly_retention_unit
    retention_value    = var.weekly_retention_value
  }
}
resource "mongodbatlas_cloud_backup_schedule" "monthly" {
  count        = var.create && local.free_tier == false && var.monthly_backup_enabled ? 1 : 0
  project_id   = mongodbatlas_project.project[0].id
  cluster_name = var.cluster_type == "REPLICASET" || local.free_tier || local.sharding ? mongodbatlas_cluster.replicaset[0].name : mongodbatlas_cluster.sharded[0].name

  reference_hour_of_day    = var.monthly_reference_hour_of_day != null ? var.monthly_reference_hour_of_day : var.reference_hour_of_day
  reference_minute_of_hour = var.monthly_reference_minute_of_hour != null ? var.monthly_reference_minute_of_hour : var.reference_minute_of_hour
  restore_window_days      = var.monthly_restore_window_days != null ? var.monthly_restore_window_days : var.restore_window_days

  // This will now add the desired policy items to the existing mongodbatlas_cloud_backup_schedule resource
  policy_item_monthly {
    frequency_interval = var.monthly_frequency_interval
    retention_unit     = var.monthly_retention_unit
    retention_value    = var.monthly_retention_value
  }
}
