# STEP 1: Use Terraform AWS VPC Module (official, from the registry)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = "qr-code-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = false

  public_subnet_tags = {
    "kubernetes.io/role/elb"                     = 1
    "kubernetes.io/cluster/qr-code-eks-cluster" = "shared"
  }

  map_public_ip_on_launch = true  # ✅ this is the key line

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "qr-code-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# STEP 2: Call your custom EKS module and pass subnet IDs from VPC
module "eks" {
  source           = "./modules/eks" # (your own EKS module path)
  cluster_name     = "qr-code-eks-cluster"
  subnet_ids       = module.vpc.public_subnets
  cluster_role_arn = aws_iam_role.eks_cluster_role.arn
}