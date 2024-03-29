module "eks" {
  source       = "../modules/eks"
  region       = local.region
  cluster_name = "mycluster"
  map_roles = [
    {
      rolearn  = "arn:aws:iam::123456789012:user/hari-cli"
      username = "cluster-admin"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::123456789012:role/AWSReservedSSO_MyGroup_1234a567b890cdef",
      username = "myrole"
      groups   = []
    }
  ]
}

