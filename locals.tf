#The module from mongodb itself is limited to AWS only for now.
locals {
  cloud_provider = "AWS"
  db_users_flat = merge(flatten([
    for username, clusters in var.db_users :
    [
      for clustername, cluster in clusters :
      {
        for idx, db_types in cluster.db_type :
        "${username}-${clustername}-${idx}" => {
          username    = username
          clustername = clustername
          cluster = {
            db_name = cluster.db_name
            db_role = cluster.db_role
            db_type = db_types
          }
        }
      }
    ]
  ])...)
}
