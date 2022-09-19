module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  version = "18.29.0"
  cluster_name = local.cluster_name
  subnet_ids = module.vpc.private_subnets
  

  tags = {
    Environment = "training"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = module.vpc.vpc_id

  eks_managed_node_groups = {
    one = {
    name = "node-group-1"

    instance_types = ["t2.small"]

    min_size     = 1
    max_size     = 3
    desired_size = 2

    pre_bootstrap_user_data = <<-EOT
    echo 'foo bar'
    EOT

    vpc_security_group_ids = [
      aws_security_group.worker_group_mgmt_one.id
      ]
  }

  two = {
    name = "node-group-2"

    instance_types = ["t2.medium"]

    min_size     = 1
    max_size     = 2
    desired_size = 1

    pre_bootstrap_user_data = <<-EOT
    echo 'foo bar'
    EOT

    vpc_security_group_ids = [
      aws_security_group.worker_group_mgmt_two.id
    ]
  }
}

}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
