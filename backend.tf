terraform {
  backend "s3" {
    bucket         = "mbpro-terraform-tfstate"
    key            = "aws/innoimpex/terraform.tfstate"
    encrypt        = true
    region         = "ap-south-1"
    use_lockfile = true   
  }
}