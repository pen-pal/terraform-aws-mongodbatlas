#Optional, if no variable is passed, the loop will run on an empty object.
resource "mongodbatlas_project_ip_access_list" "whitelists" {
  for_each = var.create ? var.whitelists : {}

  project_id = mongodbatlas_project.project[0].id
  comment    = each.key
  cidr_block = each.value

  depends_on = [
    mongodbatlas_project.project
  ]
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



