
# create Terraform data references to be able to assign users to these groups

locals {
  aws_sso_groups = [
    #"AWSAccountFactory",
    #"AWSAuditAccountAdmins",
    "AWSControlTowerAdmins",
    #"AWSLogArchiveAdmins",
    #"AWSLogArchiveViewers",
    #"AWSSecurityAuditPowerUsers",
    #"AWSSecurityAuditors",
    #"AWSServiceCatalogAdmins",
    "azure-ad--aws-admins-group",
  ]
}

data "aws_identitystore_group" "group" {
  for_each          = toset(local.aws_sso_groups)
  identity_store_id = local.sso_idp # set in aws_sso.tf
  filter {
    attribute_path  = "DisplayName"
    attribute_value = each.key
  }
}
