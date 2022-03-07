#Optionall, if no variable is passed, the loop will run on an empty object.
resource "mongodbatlas_project_ip_access_list" "whitelists" {
  for_each = var.white_lists

  project_id = mongodbatlas_project.project.id
  comment    = each.key
  cidr_block = each.value
}

#####################3###################################
## CREATE AWS PEER REQUESTS TO AWS VPC
#####################3###################################
#
#resource "mongodbatlas_network_peering" "mongo_peer" {
#  for_each = var.vpc_peer
#
#  accepter_region_name   = each.value.region
#  project_id             = mongodbatlas_project.project.id
#  container_id           = mongodbatlas_cluster.cluster.container_id
#  provider_name          = local.cloud_provider
#  route_table_cidr_block = each.value.route_table_cidr_block
#  vpc_id                 = each.value.vpc_id
#  aws_account_id         = each.value.aws_account_id
#}
#
#####################3###################################
## ACCEPT THE PEER REQUESTS ON THE AWS SIDE
#####################3###################################
#
#resource "aws_vpc_peering_connection_accepter" "peer" {
#  for_each = var.vpc_peer
#
#  vpc_peering_connection_id = mongodbatlas_network_peering.mongo_peer[each.key].connection_id
#  auto_accept               = true
#}

resource "mongodbatlas_privatelink_endpoint" "default" {
  for_each      = var.create_privatelink_endpoint == true ? 1 : 0
  project_id    = mongodbatlas_project.project.id
  provider_name = local.cloud_provider
  region        = var.region
}

resource "aws_vpc_endpoint" "ptfe_service" {
  for_each          = var.create_privatelink_endpoint == true ? 1 : 0
  vpc_id            = var.vpc_id
  service_name      = mongodbatlas_privatelink_endpoint.default.endpoint_service_name
  vpc_endpoint_type = var.vpc_endpoint_type
  subnet_ids        = var.subnet_ids
  #subnet_ids         = ["subnet-de0406d2"]
  security_group_ids = var.security_group_ids
  #security_group_ids = ["sg-3f238186"]
}

resource "mongodbatlas_privatelink_endpoint_service" "test" {
  for_each            = var.create_privatelink_endpoint == true ? 1 : 0
  project_id          = mongodbatlas_privatelink_endpoint.test.project_id
  private_link_id     = mongodbatlas_privatelink_endpoint.test.private_link_id
  endpoint_service_id = aws_vpc_endpoint.ptfe_service.id
  provider_name       = "AWS"
}
