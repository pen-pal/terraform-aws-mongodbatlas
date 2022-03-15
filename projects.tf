################################
### PROJECT
################################

resource "mongodbatlas_project" "project" {
  count  = var.create ? 1 : 0
  name   = var.project_name
  org_id = var.org_id

  #Associate teams and privileges if passed, if not - run with an empty object
  dynamic "teams" {
    for_each = var.teams
    content {
      team_id    = mongodbatlas_teams.team[teams.key].team_id
      role_names = teams.value.project_role
    }
  }

  depends_on = [
    mongodbatlas_teams.team
  ]

}
