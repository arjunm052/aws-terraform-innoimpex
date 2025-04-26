resource "aws_eks_node_group" "eks_ng_private" {
  depends_on   = [module.eks]
  cluster_name = var.cluster_name

  node_group_name = "${var.environment}-eks-ng-private"
  node_role_arn   = aws_iam_role.eks-node-role.arn
  subnet_ids      = module.vpc.private_subnets

  ami_type       = var.ami_type
  capacity_type  = var.capacity_type
  disk_size      = var.disk_size
  instance_types = var.instance_types

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  update_config {
    max_unavailable = var.max_unavailable
  }

  tags = var.node_group_tags
}