
locals {
  team_group_mapping = {
    my-github-team1 = "my-azure-ad-group1",
    my-github-team2 = "my-azure-ad-group2",
    #...
  }

  # XXX: takes ages (26 minutes) to enumerate team sync groups, so pre-materialize and don't call it for every for_each loop iteration!
  sync_groups = data.github_organization_team_sync_groups.this.groups
}

data "github_organization_team_sync_groups" "this" {}

resource "github_team_sync_group_mapping" "this" {
  for_each  = local.team_group_mapping
  team_slug = each.key

  dynamic "group" {
    for_each = [for g in local.sync_groups : g if g.group_name == each.value]
    content {
      group_id          = group.value.group_id
      group_name        = group.value.group_name
      group_description = "IDP Group ${group.value.group_name}"
      # match existing description if importing to prevent replacement
      #group_description = group.value.group_description
    }
  }
}
