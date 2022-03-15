###########################################
### TEAMS FROM **EXISTING USERS**
###########################################

resource "mongodbatlas_teams" "team" {
  for_each  = var.create ? var.teams : {}
  org_id    = var.org_id
  name      = each.key
  usernames = each.value.users
}
