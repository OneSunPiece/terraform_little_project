provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = var.env
      Project     = "Nexacloud"
      Owner       = "Nexacloud Team"
      CreatedBy   = "Terraform"
      Version     = "1.0.0"
      Course      = "Cloud Services"
    }
  }
}

# Modules

# VPC Module
module "vpc" {
  source = "./modules/vpc"
}
# EC2 Module
module "ec2" {
  source = "./modules/ec2"
  vpc_id        = module.vpc.nexacloud_vpc
  public_subnet_id = module.vpc.nexacloud_net_public
}
# RDS Module
# @todo: Deactivate RDS module for now (not working)
module "rds" {
  source = "./modules/rds"
}
# S3 Module
module "s3" {
  source = "./modules/s3"
}
# IAM Module
module "iam" {
  source = "./modules/iam"
}
# beanstalk Module
module "beanstalk" {
  source = "./modules/beanstalk"
  vpc_id = module.vpc.nexacloud_net_public
  public_subnet_id = module.vpc.nexacloud_net_public
  private_subnet_id = module.vpc.nexacloud_net_private
}
# Lambda Module
module "lambda" {
  source = "./modules/lambda"
}

