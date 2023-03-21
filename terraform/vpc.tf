module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-eks-tf"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
    repository_url = "https://github.com/matiasbertani/dummy_hello_app_infra"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/vcc-eks-tf" = "shared"
  }

}