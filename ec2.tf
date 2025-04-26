# # Fetch the latest Amazon Linux 2 AMI
# data "aws_ami" "amazon_linux_2" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*-x86_64-ebs"]
#   }
# }

# # Create an IAM role for the EC2 instance
# resource "aws_iam_role" "ec2_ssm_role" {
#   name = "ec2-ssm-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       }
#     ]
#   })

#   tags = {
#     Name = "ec2-ssm-role"
#   }
# }

# # Attach the AmazonSSMManagedInstanceCore policy to the IAM role
# resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
#   role       = aws_iam_role.ec2_ssm_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }

# # Create an IAM instance profile for the EC2 instance
# resource "aws_iam_instance_profile" "ec2_ssm_instance_profile" {
#   name = "ec2-ssm-instance-profile"
#   role = aws_iam_role.ec2_ssm_role.name
# }

# # Create a security group for the EC2 instance
# resource "aws_security_group" "ec2_sg" {
#   name        = "ec2-private-subnet-sg"
#   description = "Allow SSH and outbound traffic"
#   vpc_id      = module.vpc.vpc_id # Replace with your VPC ID

#   # Allow SSH access (for debugging or management)
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # Restrict this to your IP in production
#   }

#   # Allow all outbound traffic
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "ec2-private-subnet-sg"
#   }
# }

# # Create an EC2 instance in the private subnet
# resource "aws_instance" "ec2_private" {
#   ami                         = data.aws_ami.amazon_linux_2.id
#   instance_type               = "t2.micro"
#   subnet_id                   = module.vpc.private_subnets[0] 
#   vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
#   associate_public_ip_address = false 
#   iam_instance_profile        = aws_iam_instance_profile.ec2_ssm_instance_profile.name 

#   tags = {
#     Name = "ec2-private-instance"
#   }
# }

# # Output the private IP of the EC2 instance
# output "private_ip" {
#   value = aws_instance.ec2_private.private_ip
# }

