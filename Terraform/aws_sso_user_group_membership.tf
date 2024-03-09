
locals {
  user_groups = {
    # XXX: Edit
    "hari.sekhon@domain.com" = ["AWSControlTowerAdmins"],
    "devops2@domain.com"     = ["AWSControlTowerAdmins"],
    "devops3@domain.com"     = ["AWSControlTowerAdmins"],
  }
}

data "aws_identitystore_group" "AWSControlTowerAdmins" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.azure.identity_store_ids)[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = "AWSControlTowerAdmins"
    }
  }
}

resource "aws_identitystore_group_membership" "AWSControlTowerAdmins" {
  for_each          = local.user_groups
  identity_store_id = tolist(data.aws_ssoadmin_instances.azure.identity_store_ids)[0]
  group_id          = data.aws_identitystore_group.AWSControlTowerAdmins.group_id
  member_id         = data.aws_identitystore_user.it[each.key].user_id
}
