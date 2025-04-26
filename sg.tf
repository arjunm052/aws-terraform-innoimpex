#Security Group for Control Plane
resource "aws_security_group" "control_plane_sg" {
  name        = "EKS-Control-Plane-SG"
  description = "Security group for EKS Control Plane"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow SSH access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Replace with a specific IP range for better security
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 allows all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EKSControlPlaneSG-${var.environment}"
  }
}