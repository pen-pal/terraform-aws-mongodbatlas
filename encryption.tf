########################################
## MongoDB Atlas
########################################

resource "mongodbatlas_encryption_at_rest" "encryption" {
  count      = var.create && var.encryption_enabled ? 1 : 0
  project_id = mongodbatlas_project.project[0].id

  aws_kms_config {
    enabled                = var.encryption_enabled
    customer_master_key_id = var.customer_master_key_id == "" ? aws_kms_key.default[0].key_id : var.customer_master_key_id
    region                 = var.region #atlas region (this region should have your kms key in AWS)
    role_id                = mongodbatlas_cloud_provider_access_authorization.auth_role[0].role_id
  }

  depends_on = [
    mongodbatlas_project.project,
    mongodbatlas_cloud_provider_access_authorization.auth_role
  ]
}

resource "mongodbatlas_cloud_provider_access_setup" "setup_only" {
  count         = var.create && var.encryption_enabled ? 1 : 0
  project_id    = mongodbatlas_project.project[0].id
  provider_name = var.cloud_provider

  depends_on = [
    mongodbatlas_project.project
  ]
}

resource "mongodbatlas_cloud_provider_access_authorization" "auth_role" {
  count      = var.create && var.encryption_enabled ? 1 : 0
  project_id = mongodbatlas_project.project[0].id
  role_id    = mongodbatlas_cloud_provider_access_setup.setup_only[0].role_id

  aws {
    iam_assumed_role_arn = aws_iam_role.role[0].arn
  }

  depends_on = [
    aws_iam_role.role,
    mongodbatlas_cloud_provider_access_setup.setup_only,
    mongodbatlas_project.project
  ]
}
