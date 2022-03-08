#The module from mongodb itself is limited to AWS only for now.
locals {
  cloud_provider = "AWS"
  db_users_flat = merge([
    for lists, users in var.db_users :
    {
      for user, data in users :
      "${lists}-${user}" => {
        username = user
        #clustertype = clustertype
        #clustername = clustername
        cluster = data
      }
    }
  ]...) # please do NOT remove the dots
}

#
#output "val" {
#  value = local.db_users_flat
#}
#
#output "v" {
#  value = local.teams_flat
#}
#
#output "a" {
#  value = local.sets
#}
#
##output "ty" {
##  value = local.new
##}
#
#output "teams" {
#  value = local.teams_id
#}
#
#
##output "tfeam-id-with-teams" {
##  value = local.final
##}
##
##output "new" {
##  value = local.new
##}
#
#
#output "stg" {
#  value = local.users
#}
