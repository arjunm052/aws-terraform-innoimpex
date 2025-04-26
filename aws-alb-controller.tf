# Create IRSA for AWS Load Balancer Controller
module "load_balancer_controller_irsa_role" {
  source                                 = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                                = "5.42.0"
  role_name                              = "load-balancer-controller-eks-role-${var.environment}"
  attach_load_balancer_controller_policy = true
  oidc_providers = {
    eks-cluster = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
  tags = {
    tag-key = "AWSLoadBalancerControllerIAMPolicy"
  }
}

# Install AWS Load Balancer Controller using HELM
# Resource: Helm Release 
resource "helm_release" "loadbalancer_controller" {
  #   depends_on = [aws_iam_role.lbc_iam_role, aws_eks_node_group.eks_ng_private]
  depends_on = [module.load_balancer_controller_irsa_role, aws_eks_node_group.eks_ng_private, module.eks]
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = var.aws_alb_controller_version
  namespace  = "kube-system"

  # Value changes based on your Region (Below is for us-east-1)
  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.ap-south-1.amazonaws.com/amazon/aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.load_balancer_controller_irsa_role.iam_role_arn
  }

  set {
    name  = "vpcId"
    value = module.vpc.vpc_id
  }

  set {
    name  = "region"
    value = var.aws_region
  }

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }

}
