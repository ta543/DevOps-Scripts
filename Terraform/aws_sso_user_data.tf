
# populate AWS SSO user data to assign to built-in permsets

locals {
  sso_users = [
    "hari.sekhon@domain.com",
    "devops2@domain.com",
    "devops3@domain.com",
  ]
}

data "aws_ssoadmin_instances" "azure" {}

data "aws_identitystore_user" "it" {
  for_each          = toset(local.sso_users)
  identity_store_id = tolist(data.aws_ssoadmin_instances.azure.identity_store_ids)[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "UserName"
      attribute_value = each.key
    }
  }
}
