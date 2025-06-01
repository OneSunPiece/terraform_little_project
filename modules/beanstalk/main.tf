resource "aws_elastic_beanstalk_application" "Nexacloud" {
  name        = "Nexacloud"
  description = "Nexacloud Elastic Beanstalk Application"
}

resource "aws_elastic_beanstalk_environment" "beanstalk_env" {
  name                = "nexacloud-dev"
  description         = "Elastic Beanstalk Environment for cloud services course"
  tier                = "WebServer"
  application         = aws_elastic_beanstalk_application.Nexacloud.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.5.2 running Python 3.13"

  // VPC
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${var.public_subnet_id},${var.private_subnet_id}"
  }
  // Autoscaling
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t3.micro"
  }
  // Load Balancing
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }
  // Health Checks
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "2"
  }
}