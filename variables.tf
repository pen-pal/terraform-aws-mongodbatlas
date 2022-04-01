#can be exported as 'export MONGODB_ATLAS_PRIVATE_KEY="xxxx"'
variable "create" {
  description = "Flag to ensuer either to create or not  create the resource"
  type        = bool
  default     = true
}

variable "mongodbatlas_public_key" {
  description = "This is the public key of your MongoDB Atlas '' API key pair"
  type        = string
  default     = ""
}

#can be exported as 'export MONGODB_ATLAS_PRIVATE_KEY="xxxx"'
variable "mongodbatlas_private_key" {
  description = "This is the private key of your MongoDB Atlas API key pair"
  type        = string
  default     = ""
}

variable "cloud_provider" {
  description = "Cloud service provider on which the servers are provisioned. The possible values are: AWS, GCP, AZURE, and (... TENANT - A multi-tenant deployment on one of the supported cloud service providers. Only valid when providerSettings.instanceSizeName is either M2 or M5. ...)"
  type        = string
  default     = "AWS"
}

variable "backing_provider_name" {
  description = "Cloud service provider on which the server for a multi-tenant cluster is provisioned. This setting is only valid when providerSetting.providerName is TENANT and providerSetting.instanceSizeName is M2 or M5. The possible values are: AWS, GCP, AZURE"
  type        = string
  default     = "AWS"
}

variable "project_name" {
  description = "The name of the project you want to create"
  type        = string
  default     = ""
}

variable "org_id" {
  description = "The ID of the Atlas organization you want to create the project within"
  type        = string
  default     = ""
}

variable "teams" {
  description = "An object that contains all the groups that should be created in the project"
  type        = any
  default     = {}
}

variable "db_users" {
  description = "An object that contains all the groups that should be created in the project"
  type        = map(any)
  default     = {}
}

variable "whitelists" {
  description = "An object that contains all the network white-lists that should be created in the project"
  type        = map(any)
  #default     = {}
  default = { "example" : "202.51.88.91/32" }
}

variable "atlas_region" {
  description = "The AWS region-name that the cluster will be deployed on"
  type        = string
  default     = "US_EAST_1"
}

variable "aws_region" {
  description = "The AWS region-name that the AWS KMS KEY, Private Link, and other resides on"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "The cluster name"
  type        = string
  default     = "ClusterMongo"
}

variable "instance_type" {
  description = "The Atlas instance-type name"
  type        = string
  default     = "M10"
}

variable "mongodb_major_ver" {
  description = "The MongoDB cluster major version"
  type        = number
  default     = 5.0
}

variable "cluster_type" {
  description = "The MongoDB Atlas cluster type - SHARDED/REPLICASET/GEOSHARDED"
  type        = string
  default     = "REPLICASET"
}

variable "num_shards" {
  description = " Number of shards to deploy in the specified zone, minimum 1."
  type        = number
  default     = 1
}

variable "num_shards_replicaset" {
  description = " Number of shards to deploy in the specified zone, minimum 1."
  type        = number
  default     = 2
}

variable "replication_factor" {
  description = " Number of replica set members. Each member keeps a copy of your databases, providing high availability and data redundancy. The possible values are 3, 5, or 7. The default value is 3."
  type        = number
  default     = null
}

#variable "replication_specs_replicaset" {
variable "replication_specs" {
  description = "An object that contains all the groups that should be created in the project"
  type        = list(map(any))
  default     = null
}
variable "replication_specs_sharded" {
  description = "An object that contains all the groups that should be created in the project"
  type        = list(map(any))
  default     = null
}

variable "electable_nodes" {
  description = "Number of electable nodes for Atlas to deploy to the region. Electable nodes can become the primary and can facilitate local reads. The total number of electableNodes across all replication spec regions must total 3, 5, or 7. Specify 0 if you do not want any electable nodes in the region.You cannot create electable nodes in a region if priority is 0."
  type        = number
  default     = 3
}

variable "priority" {
  description = "Election priority of the region. For regions with only read-only nodes, set this value to 0. For regions where electable_nodes is at least 1, each region must have a priority of exactly one (1) less than the previous region. The first region must have a priority of 7. The lowest possible priority is 1. The priority 7 region identifies the Preferred Region of the cluster. Atlas places the primary node in the Preferred Region. Priorities 1 through 7 are exclusive - no more than one region per cluster can be assigned a given priority. Example: If you have three regions, their priorities would be 7, 6, and 5 respectively. If you added two more regions for supporting electable nodes, the priorities of those regions would be 4 and 3 respectively."
  type        = number
  default     = 7
}

variable "read_only_nodes" {
  description = "Number of read-only nodes for Atlas to deploy to the region. Read-only nodes can never become the primary, but can facilitate local-reads. Specify 0 if you do not want any read-only nodes in the region."
  type        = number
  default     = 0
}

variable "analytics_nodes" {
  description = "The number of analytics nodes for Atlas to deploy to the region. Analytics nodes are useful for handling analytic data such as reporting queries from BI Connector for Atlas. Analytics nodes are read-only, and can never become the primary. If you do not specify this option, no analytics nodes are deployed to the region."
  type        = number
  default     = 0
}
#NOTE: Set this to true for M0 cluster if you have credit card associated to MongoDB else set it to false as it cannot be enabled unless credit card is associated
variable "cloud_backup" {
  description = "Flag indicating if the cluster uses Cloud Backup for backups. Deprecated use cloud_backup instead."
  type        = bool
  default     = true
}

#NOTE: Set this to true for M0 cluster if you have credit card associated to MongoDB else set it to false as it cannot be enabled unless credit card is associated
variable "pit_enabled" {
  description = "Indicating if the cluster uses Continuous Cloud Backup, if set to true - provider_backup must also be set to true"
  type        = bool
  default     = true
}

variable "backup_enabled" {
  description = "Legacy Backup - Set to true to enable Atlas legacy backups for the cluster. Important - MongoDB deprecated the Legacy Backup feature. Clusters that use Legacy Backup can continue to use it"
  type        = bool
  default     = false
}

variable "disk_size_gb" {
  description = "Capacity,in gigabytes,of the host’s root volume"
  type        = number
  default     = 50
}

variable "auto_scaling_disk_gb_enabled" {
  description = "Indicating if disk auto-scaling is enabled"
  type        = bool
  default     = true
}

variable "volume_type" {
  description = "The type of the volume. The possible values are: STANDARD and PROVISIONED. PROVISIONED is ONLY required if setting IOPS higher than the default instance IOPS. This value is for AWS only"
  type        = string
  default     = "STANDARD"
}

variable "provider_disk_iops" {
  description = "The maximum input/output operations per second (IOPS) the system can perform. The possible values depend on the selected provider_instance_size_name and disk_size_gb. This setting requires that provider_instance_size_name to be M30 or greater and cannot be used with clusters with local NVMe SSDs. The default value for provider_disk_iops is the same as the cluster tier's Standard IOPS value, as viewable in the Atlas console. It is used in cases where a higher number of IOPS is needed and possible. If a value is submitted that is lower or equal to the default IOPS value for the cluster tier Atlas ignores the requested value and uses the default. More details available under the providerSettings.diskIOPS parameter"
  type        = number
  default     = null
}


#NOTE: Required if autoScaling.compute.enabled is true.
variable "provider_auto_scaling_compute_max_instance_size" {
  description = "Maximum instance size to which your cluster can automatically scale (e.g., M40)."
  type        = string
  default     = ""
}

variable "provider_auto_scaling_compute_min_instance_size" {
  description = "Minimum instance size to which your cluster can automatically scale (e.g., M10)."
  type        = string
  default     = ""
}

#NOTE: If auto_scaling_compute_enabled is true, then Atlas will automatically scale up to the maximum provided and down to the minimum, if provided. This will cause the value of provider_instance_size_name returned to potential be different than what is specified in the Terraform config and if one then applies a plan, not noting this, Terraform will scale the cluster back down to the original instanceSizeName value. To prevent this a lifecycle customization should be used, i.e.:
# lifecycle { ignore_changes = [provider_instance_size_name] }
# But in order to explicitly change provider_instance_size_name comment the lifecycle block and run terraform apply. Please ensure to uncomment it to prevent any accidental changes.
variable "auto_scaling_compute_enabled" {
  description = "Specifies whether cluster tier auto-scaling is enabled. The default is false. Set to true to enable cluster tier auto-scaling. Set to false to disable cluster tier auto-scaling. "
  type        = bool
  default     = false
}

#This option is only available if autoScaling.compute.enabled is true.
variable "auto_scaling_compute_scale_down_enabled" {
  description = "Specifies whether cluster tier auto-scaling is enabled. The default is false. Set to true to enable cluster tier to scale down."
  type        = bool
  default     = false
}

variable "encryption_at_rest_provider" {
  description = "Possible values are AWS, GCP, AZURE or NONE. Only needed if you desire to manage the keys, see Encryption at Rest using Customer Key Management for complete documentation. You must configure encryption at rest for the Atlas project before enabling it on any cluster in the project. For complete documentation on configuring Encryption at Rest, see Encryption at Rest using Customer Key Management. Requires M10 or greater. and for legacy backups, backup_enabled, to be false or omitted. Note: Atlas encrypts all cluster storage and snapshot volumes, securing all cluster data on disk: a concept known as encryption at rest, by default."
  type        = string
  default     = "NONE"
}

############################
## Encryption at rest
############################
variable "encryption_enabled" {
  description = "Specifies whether Encryption at Rest is enabled for an Atlas project, To disable Encryption at Rest, pass only this parameter with a value of false, When you disable Encryption at Rest, Atlas also removes the configuration details."
  default     = false
  type        = bool
}

variable "customer_master_key_id" {
  description = "The AWS customer master key used to encrypt and decrypt the MongoDB master keys."
  type        = string
  default     = ""
}

variable "role_id" {
  description = "ID of an AWS IAM role authorized to manage an AWS customer master key. To find the ID for an existing IAM role check the role_id attribute of the mongodbatlas_cloud_provider_access resource"
  type        = string
  default     = ""
}

variable "iam_assumed_role_arn" {
  description = "ARN of the IAM Role that Atlas assumes when accessing resources in your AWS account. This value is required after the creation (register of the role) as part of Set Up Unified AWS Access."
  type        = string
  default     = ""
}
#######################################
### Cloud Backup Schedule
#######################################
variable "reference_hour_of_day" {
  description = "UTC Hour of day between 0 and 23, inclusive, representing which hour of the day that Atlas takes snapshots for backup policy items."
  type        = number
  default     = 3
}
variable "reference_minute_of_hour" {
  description = ") UTC Minutes after reference_hour_of_day that Atlas takes snapshots for backup policy items. Must be between 0 and 59, inclusive."
  type        = number
  default     = 45
}
variable "restore_window_days" {
  description = "Number of days back in time you can restore to with point-in-time accuracy. Must be a positive, non-zero integer."
  type        = number
  default     = 4
}
variable "hourly_reference_hour_of_day" {
  description = "UTC Hour of day between 0 and 23, inclusive, representing which hour of the day that Atlas takes snapshots for backup policy items."
  type        = number
  default     = null
}
variable "hourly_reference_minute_of_hour" {
  description = ") UTC Minutes after reference_hour_of_day that Atlas takes snapshots for backup policy items. Must be between 0 and 59, inclusive."
  type        = number
  default     = null
}
variable "hourly_restore_window_days" {
  description = "Number of days back in time you can restore to with point-in-time accuracy. Must be a positive, non-zero integer."
  type        = number
  default     = null
}
variable "daily_reference_minute_of_hour" {
  description = ") UTC Minutes after reference_hour_of_day that Atlas takes snapshots for backup policy items. Must be between 0 and 59, inclusive."
  type        = number
  default     = null
}
variable "daily_restore_window_days" {
  description = "Number of days back in time you can restore to with point-in-time accuracy. Must be a positive, non-zero integer."
  type        = number
  default     = null
}
variable "daily_reference_hour_of_day" {
  description = "UTC Hour of day between 0 and 23, inclusive, representing which hour of the day that Atlas takes snapshots for backup policy items."
  type        = number
  default     = null
}
variable "weekly_reference_minute_of_hour" {
  description = ") UTC Minutes after reference_hour_of_day that Atlas takes snapshots for backup policy items. Must be between 0 and 59, inclusive."
  type        = number
  default     = null
}
variable "weekly_restore_window_days" {
  description = "Number of days back in time you can restore to with point-in-time accuracy. Must be a positive, non-zero integer."
  type        = number
  default     = null
}
variable "weekly_reference_hour_of_day" {
  description = "UTC Hour of day between 0 and 23, inclusive, representing which hour of the day that Atlas takes snapshots for backup policy items."
  type        = number
  default     = null
}
variable "monthly_reference_hour_of_day" {
  description = "UTC Hour of day between 0 and 23, inclusive, representing which hour of the day that Atlas takes snapshots for backup policy items."
  type        = number
  default     = null
}
variable "monthly_reference_minute_of_hour" {
  description = ") UTC Minutes after reference_hour_of_day that Atlas takes snapshots for backup policy items. Must be between 0 and 59, inclusive."
  type        = number
  default     = null
}
variable "monthly_restore_window_days" {
  description = "Number of days back in time you can restore to with point-in-time accuracy. Must be a positive, non-zero integer."
  type        = number
  default     = null
}

#policy_item_hourly
variable "hourly_backup_enabled" {
  description = "Enable hourly backup for your cluster."
  type        = bool
  default     = true
}

variable "hourly_frequency_interval" {
  description = "Desired frequency of the new backup policy item specified by frequency_type"
  type        = number
  default     = 1
}

variable "hourly_retention_unit" {
  description = "Scope of the backup policy item: days, weeks, or months."
  type        = string
  default     = "days"
}

variable "hourly_retention_value" {
  description = "Value to associate with retention_unit"
  type        = number
  default     = 1
}

#policy_item_daily
variable "daily_backup_enabled" {
  description = "Enable hourly backup for your cluster."
  type        = bool
  default     = true
}

variable "daily_frequency_interval" {
  description = "Desired frequency of the new backup policy item specified by frequency_type"
  type        = number
  default     = 1
}

variable "daily_retention_unit" {
  description = "Scope of the backup policy item: days, weeks, or months."
  type        = string
  default     = "days"
}

variable "daily_retention_value" {
  description = "Value to associate with retention_unit"
  type        = number
  default     = 2
}

#policy_item_weekly
variable "weekly_backup_enabled" {
  description = "Enable hourly backup for your cluster."
  type        = bool
  default     = false
}

variable "weekly_frequency_interval" {
  description = "Desired frequency of the new backup policy item specified by frequency_type"
  type        = number
  default     = 4
}

variable "weekly_retention_unit" {
  description = "Scope of the backup policy item: days, weeks, or months."
  type        = string
  default     = "weeks"
}

variable "weekly_retention_value" {
  description = "Value to associate with retention_unit"
  type        = number
  default     = 3
}

#policy_item_monthly
variable "monthly_backup_enabled" {
  description = "Enable hourly backup for your cluster."
  type        = bool
  default     = false
}
variable "monthly_frequency_interval" {
  description = "Desired frequency of the new backup policy item specified by frequency_type"
  type        = number
  default     = 5
}

variable "monthly_retention_unit" {
  description = "Scope of the backup policy item: days, weeks, or months."
  type        = string
  default     = "months"
}

variable "monthly_retention_value" {
  description = "Value to associate with retention_unit"
  type        = number
  default     = 4
}

variable "labels" {
  description = "Key-value pairs that tag and categorize the cluster. Each key and value has a maximum length of 255 characters. You cannot set the key Infrastructure Tool, it is used for internal purposes to track aggregate usage."
  type        = map(any) #list(map(string))
  default     = {}       #[{}]
}


##########################################
### AWS Resources
##########################################
variable "deletion_window_in_days" {
  type        = number
  default     = 30
  description = "Duration in days after which the key is deleted after destruction of the resource"
}

variable "enable_key_rotation" {
  type        = bool
  default     = true
  description = "Specifies whether key rotation is enabled"
}

variable "description" {
  type        = string
  default     = "Parameter Store KMS master key"
  description = "The description of the key as viewed in AWS console"
}

variable "alias" {
  type        = string
  default     = ""
  description = "The display name of the alias. The name must start with the word `alias` followed by a forward slash. If not specified, the alias name will be auto-generated."
}

variable "policy" {
  type        = string
  default     = ""
  description = "A valid KMS policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the verbose/specific version of the policy."
}

variable "key_usage" {
  type        = string
  default     = "ENCRYPT_DECRYPT"
  description = "Specifies the intended use of the key. Valid values: `ENCRYPT_DECRYPT` or `SIGN_VERIFY`."
}

variable "customer_master_key_spec" {
  type        = string
  default     = "SYMMETRIC_DEFAULT"
  description = "Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: `SYMMETRIC_DEFAULT`, `RSA_2048`, `RSA_3072`, `RSA_4096`, `ECC_NIST_P256`, `ECC_NIST_P384`, `ECC_NIST_P521`, or `ECC_SECG_P256K1`."
}

variable "multi_region" {
  type        = bool
  default     = false
  description = "Indicates whether the KMS key is a multi-Region (true) or regional (false) key."
}

variable "vpc_peer" {
  description = "An object that contains all VPC peering requests from the cluster to AWS VPC's"
  type        = map(any)
  default     = {}
}

variable "create_privatelink_endpoint" {
  description = "Either to create privatelink endpoint or not"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "The ID of the VPC in which the endpoint will be used."
  type        = string
  default     = ""
}

variable "vpc_endpoint_type" {
  description = "The VPC endpoint type, Gateway, GatewayLoadBalancer, or Interface"
  type        = string
  default     = "Interface"
}

variable "subnet_ids" {
  description = "The ID of one or more subnets in which to create a network interface for the endpoint. Applicable for endpoints of type GatewayLoadBalancer and Interface."
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "The ID of one or more security groups to associate with the network interface. Required for endpoints of type Interface."
  type        = list(string)
  default     = []
}


variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}

}
