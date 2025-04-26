module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  create_iam_role = var.create_iam_role

  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access

  cluster_additional_security_group_ids = [aws_security_group.control_plane_sg.id]
  access_entries                        = { for entry in var.access_entries : entry.principal_arn => entry }

  cluster_addons = var.cluster_addons

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  tags = var.eks_tags
}
