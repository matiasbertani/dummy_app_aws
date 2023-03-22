module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.22"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  eks_managed_node_groups = {
      group1 = {
        min_size     = 1
        max_size     = 3
        desired_size = 1

        instance_types = ["t3.large"]
      }
    }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

}
