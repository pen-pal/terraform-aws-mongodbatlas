#######################################
### AWS KMS Key
#######################################
resource "aws_kms_key" "default" {
  count                    = var.create && var.encryption_enabled ? 1 : 0
  deletion_window_in_days  = var.deletion_window_in_days
  enable_key_rotation      = var.enable_key_rotation
  policy                   = var.policy
  description              = var.description
  key_usage                = var.key_usage
  customer_master_key_spec = var.customer_master_key_spec
  multi_region             = var.multi_region
  tags                     = var.tags
}

resource "aws_kms_alias" "default" {
  count = var.create && var.encryption_enabled ? 1 : 0
  name  = var.alias
  #name          = coalesce(var.alias, format("alias/%v", module.this.id))
  target_key_id = join("", aws_kms_key.default.*.id)
}
########################################
### AWS Roles
########################################
resource "aws_iam_role_policy" "policy" {
  count  = var.create && var.encryption_enabled ? 1 : 0
  name   = "mongodb_atlas_setup_policy"
  role   = aws_iam_role.role[0].id
  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
		"Action": "*",
		"Resource": "*"
      }
    ]
  }
  EOF
  depends_on = [
    aws_iam_role.role
  ]
}

resource "aws_iam_role" "role" {
  count = var.create && var.encryption_enabled ? 1 : 0
  name  = "mongodb_setup_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${mongodbatlas_cloud_provider_access_setup.setup_only[0].aws_config[0].atlas_aws_account_arn}"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "${mongodbatlas_cloud_provider_access_setup.setup_only[0].aws_config[0].atlas_assumed_role_external_id}"
        }
      }
    }
  ]
}
EOF
}
########################################################
### Mongdb atlas and AWS VPC Private Link
########################################################
resource "mongodbatlas_privatelink_endpoint" "default" {
  count         = local.free_tier == false && var.create && var.create_privatelink_endpoint == true ? 1 : 0
  project_id    = mongodbatlas_project.project[0].id
  provider_name = local.cloud_provider
  region        = var.aws_region
}

resource "aws_vpc_endpoint" "ptfe_service" {
  count              = local.free_tier == false && var.create && var.create_privatelink_endpoint == true ? 1 : 0
  vpc_id             = var.vpc_id
  service_name       = mongodbatlas_privatelink_endpoint.default[0].endpoint_service_name
  vpc_endpoint_type  = var.vpc_endpoint_type
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids

  depends_on = [
    mongodbatlas_privatelink_endpoint.default
  ]
}

resource "mongodbatlas_privatelink_endpoint_service" "test" {
  count               = local.free_tier == false && var.create && var.create_privatelink_endpoint == true ? 1 : 0
  project_id          = mongodbatlas_project.project[0].id
  private_link_id     = mongodbatlas_privatelink_endpoint.default[0].private_link_id
  endpoint_service_id = aws_vpc_endpoint.ptfe_service[0].id
  provider_name       = "AWS"

  depends_on = [
    mongodbatlas_privatelink_endpoint.default,
    aws_vpc_endpoint.ptfe_service
  ]

}
