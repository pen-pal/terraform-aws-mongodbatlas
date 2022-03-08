########################################
## AWS Roles
########################################
resource "aws_iam_role_policy" "policy" {
  count = var.enabled == true ? 1 : 0
  name  = "mongodb_atlas_setup_policy"
  role  = aws_iam_role.role[0].id

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
  count = var.enabled == true ? 1 : 0
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

########################################
## MongoDB Atlas
########################################

resource "mongodbatlas_encryption_at_rest" "encryption" {
  count      = var.enabled == true ? 1 : 0
  project_id = mongodbatlas_project.project.id

  aws_kms_config {
    enabled                = var.enabled
    customer_master_key_id = var.customer_master_key_id
    region                 = var.region #atlas region (this region should have your kms key in AWS)
    role_id                = mongodbatlas_cloud_provider_access_authorization.auth_role[0].role_id
  }

  depends_on = [
    mongodbatlas_project.project,
    mongodbatlas_cloud_provider_access_authorization.auth_role
  ]
}

resource "mongodbatlas_cloud_provider_access_setup" "setup_only" {
  count         = var.enabled == true ? 1 : 0
  project_id    = mongodbatlas_project.project.id
  provider_name = var.cloud_provider

  depends_on = [
    mongodbatlas_project.project
  ]
}

resource "mongodbatlas_cloud_provider_access_authorization" "auth_role" {
  count      = var.enabled == true ? 1 : 0
  project_id = mongodbatlas_project.project.id
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
