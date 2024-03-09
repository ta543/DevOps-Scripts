
# ============================================================================ #
#              A W S   S S O   A c c o u n t   A s s i g n m e n t
# ============================================================================ #

locals {
  group_permset_map_dev = {
    myproject-aws-admins = [
      "AWSAdministratorAccess",
      "AWSPowerUserAccess",
    ]
    myproject-aws-auditor         = ["AWSReadOnlyAccess"]
    myproject-aws-billing         = ["Billing"]
    myproject-aws-data-developers = ["DataDevelopers"]
    myproject-aws-developer       = ["AWSPowerUserAccess"]
    myproject-aws-users           = ["AWSReadOnlyAccess"]
  }

  group_permset_map_dev_expanded = flatten([
    for group, permsets in local.group_permset_map_dev : [
      for permset in permsets : {
        group   = group
        permset = permset
      }
    ]
  ])

}

# XXX: assign groups to permsets in the Dev account - nowhere else should developers have such AWSPowerUserAccess access
resource "aws_ssoadmin_account_assignment" "dev" {
  for_each = {
    for kv in local.group_permset_map_dev_expanded :
    "${kv.group}.${kv.permset}" => kv
  }

  instance_arn       = local.sso_arn
  permission_set_arn = aws_ssoadmin_permission_set.set[each.value.permset].arn
  principal_id       = data.aws_identitystore_group.group[each.value.group].group_id
  principal_type     = "GROUP"
  target_type        = "AWS_ACCOUNT"
  target_id          = local.account_id_dev
}
