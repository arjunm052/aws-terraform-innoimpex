variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment Name"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
}

variable "db_subnets" {
  description = "List of database subnet CIDR blocks"
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Enable NAT gateway"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT gateway"
  type        = bool
  default     = true
}

variable "enable_vpn_gateway" {
  description = "Enable VPN gateway"
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = "Enable DNS support"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames"
  type        = bool
  default     = true
}

variable "map_public_ip_on_launch" {
  description = "Map Public IP on Launch"
  type        = bool
  default     = true
}

variable "vpc_tags" {
  description = "Tags for the VPC"
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "Tags for public subnets"
  type        = map(string)
  default = {
    type                     = "public"
    "kubernetes.io/role/elb" = "1"
  }
}

variable "private_subnet_tags" {
  description = "Tags for private subnets"
  type        = map(string)
  default = {
    type                              = "private"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

#EKS Config

#IAM Role for Worker Nodes
variable "iam_name" {
  type    = string
  default = "demo-app"
}

variable "iam_policy_arns" {
  type    = set(string)
  default = []
}

# Access Entries to Grant Access to Users and Roles
variable "access_entries" {
  description = "List of access entries for the EKS cluster"
  type = list(object({
    kubernetes_groups = list(string)
    principal_arn     = string
    policy_associations = map(object({
      policy_arn = string
      access_scope = object({
        # namespaces = list(string)
        type = string
      })
    }))
  }))
  default = []
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.30"
}

variable "create_iam_role" {
  description = "Whether to create an IAM role for the EKS cluster"
  type        = bool
  default     = true
}

variable "cluster_endpoint_private_access" {
  description = "Enable private access to the Kubernetes API server"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access" {
  description = "Enable public access to the Kubernetes API server"
  type        = bool
  default     = true
}

variable "cluster_addons" {
  description = "EKS cluster addons"
  type        = map(any)
  default = {
    eks-pod-identity-agent = {}
  }
}

variable "eks_tags" {
  description = "Tags for the EKS cluster"
  type        = map(string)
  default = {
    Environment = "dev"
    Terraform   = "true"
  }
}

#Node Group Config
variable "ami_type" {
  description = "AMI type for the worker nodes"
  type        = string
  default     = "AL2_x86_64"
}

variable "capacity_type" {
  description = "Capacity type (SPOT or ON_DEMAND)"
  type        = string
  default     = "SPOT"
}

variable "disk_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
  default     = 20
}

variable "instance_types" {
  description = "List of instance types for the node group"
  type        = list(string)
  default     = ["t3.small"]
}

variable "ec2_ssh_key" {
  description = "SSH key pair name for remote access"
  type        = string
}

variable "source_security_group_ids" {
  description = "List of security group IDs allowed to SSH"
  type        = list(string)
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "max_unavailable" {
  description = "Maximum unavailable nodes during update"
  type        = number
  default     = 1
}

variable "node_group_tags" {
  description = "Tags for the node group"
  type        = map(string)
  default = {
    Name = "Private-Node-Group"
  }
}

#EKS Add Ons

variable "aws_alb_controller_version" {
  description = "Version of AWS ALB Controller To use"
  type        = string
}

variable "cluster_autoscaler_version" {
  description = "Version of Cluster Autoscaler To use"
  type        = string
}

variable "ebs_csi_version" {
  description = "Version of EBS CSI Driver To use"
  type        = string
}

variable "metrics_server_version" {
  description = "Version of Metrics Server Helm Chart To use"
  type        = string
}