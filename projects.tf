################################
### PROJECT
################################

resource "mongodbatlas_project" "project" {
  name   = var.project_name
  org_id = var.org_id

  #Associate teams and privileges if passed, if not - run with an empty object
  dynamic "teams" {
    #for_each = var.teams
    #content {
    #  team_id    = "1234"    #mongodbatlas_teams.team.team_id
    #  role_names = ["admin"] #[teams.value.role]
    #}

    for_each = var.teams
    content {
      team_id    = mongodbatlas_teams.team[teams.key].team_id
      role_names = teams.value.project_role
    }

    #for_each = local.teams_id
    #content {
    #  role_names = each.value
    #  team_id    = each.value.teams_id
    #  #role_names = local.teams_id.new.new.project_role
    #  #team_id    = local.teams_id.team_id
    #  #role_names = ["admin"] #each.value.new.project_role
    #}
  }

}
