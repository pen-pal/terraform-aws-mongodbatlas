###########################################
### TEAMS FROM **EXISTING USERS**
###########################################

resource "mongodbatlas_teams" "team" {
  for_each  = var.teams
  org_id    = var.org_id
  name      = each.key
  usernames = each.value.users

  #org_id    = var.org_id
  #name      = "DevOps"
  #usernames = ["manish@altada.com"]

  #depends_on = [
  #  mongodbatlas_org_invitation.invite
  #]
}
