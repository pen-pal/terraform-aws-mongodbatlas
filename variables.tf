#can be exported as 'export MONGODB_ATLAS_PRIVATE_KEY="xxxx"'
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

variable "white_lists" {
  description = "An object that contains all the network white-lists that should be created in the project"
  type        = map(any)
  #default     = {}
  default = { "example" : "202.51.88.91/32" }
}

variable "region" {
  description = "The AWS region-name that the cluster will be deployed on"
  type        = string
  default     = "EU_WEST_1"
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

variable "replication_factor" {
  description = " Number of replica set members. Each member keeps a copy of your databases, providing high availability and data redundancy. The possible values are 3, 5, or 7. The default value is 3."
  type        = number
  default     = null
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

variable "db_users" {
  description = "An object that contains all the groups that should be created in the project"
  type        = map(any)
  default     = {}
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

#Example of db_users
#db_users = {
#  test_user1 = {      #user
#    test_cluster1 = { #cluster
#      db_name = ["db_a", "db_b", "db_c"]
#      db_role = ["readWrite", "read", "readWrite"]
#      db_type = [["CLUSTER"], ["DATALAKE"], ["CLUSTER", "DATALAKE"]]
#    },
#    test_cluster2 = {
#      db_name = ["db_a", "db_b", "db_c"]
#      db_role = ["readWrite", "read", "readWrite"]
#      #db_type = ["CLUSTER", "CLUSTER", "CLUSTER"]
#      db_type = [["CLUSTER", "DATALAKE"], ["CLUSTER", "DATALAKE"], ["CLUSTER", "DATALAKE"]]
#    }
#  },
#  test_user2 = {
#    test_cluster1 = {
#      db_name = ["db_d", "db_e", "db_f"]
#      db_role = ["readWrite", "readWrite", "read"]
#      #db_type = [["CLUSTER", "DATALAKE"], ["CLUSTER", "DATALAKE"], ["CLUSTER", "DATALAKE"]]
#      db_type = [["CLUSTER", "DATALAKE"], ["CLUSTER", "DATALAKE"], ["CLUSTER"]]
#    },
#    test_cluster2 = {
#      db_name = ["db_d", "db_e", "db_f"]
#      db_role = ["readWrite", "readWrite", "read"]
#      db_type = [["CLUSTER", "DATALAKE"], ["CLUSTER", "DATALAKE"], ["CLUSTER", "DATALAKE"]]
#      #db_type = ["CLUSTER", "CLUSTER", "CLUSTER"]
#    }
#  }
#}
