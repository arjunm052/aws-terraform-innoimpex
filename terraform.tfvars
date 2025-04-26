aws_region  = "ap-south-1"
environment = "development"

#VPC Configuration
vpc_name = "innoimpex-vpc"
vpc_cidr = "10.0.0.0/16"

availability_zones = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]

public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
# db_subnets      = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]

enable_nat_gateway      = true
single_nat_gateway      = true
enable_dns_support      = true
enable_dns_hostnames    = true
map_public_ip_on_launch = true

vpc_tags = {
  Environment = "development"
  Owner       = "DevOps Team"
}

private_subnet_tags = {
  type                              = "private"
  "kubernetes.io/role/internal-elb" = "1"
}

public_subnet_tags = {
  type                     = "public"
  "kubernetes.io/role/elb" = "1"
}


#EKS Config
iam_name        = "EKS-Worker-Node-Role"
iam_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore", "arn:aws:iam::aws:policy/AmazonEC2FullAccess", "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]

cluster_name    = "innoimpex-cluster"
cluster_version = "1.31"
create_iam_role = true

cluster_endpoint_private_access = true
cluster_endpoint_public_access  = true

cluster_addons = {
  eks-pod-identity-agent = {}
}

eks_tags = {
  Environment = "development"
  Terraform   = "true"
}


#Access Entries for EKS Cluster
access_entries = [
  {
    kubernetes_groups = []
    principal_arn     = "arn:aws:iam::734236353704:user/arjun"
    policy_associations = {
      example = {
        policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        access_scope = {
          type = "cluster"
        }
      }
    }
  }
]

#Node Group Configuration
ami_type       = "AL2_x86_64"
capacity_type  = "SPOT"
disk_size      = 20
instance_types = ["t3.medium"]

ec2_ssh_key               = "eks-keypair"
source_security_group_ids = ["sg-12345678"]

desired_size    = 1
min_size        = 1
max_size        = 3
max_unavailable = 1

node_group_tags = {
  Environment = "development"
  Terraform   = "true"
}

#EKS Add Ons Config
aws_alb_controller_version = "1.8.1"

cluster_autoscaler_version = "9.43.2"

ebs_csi_version = "v1.32.0-eksbuild.1"

metrics_server_version = "3.12.2"
