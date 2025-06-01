variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0953476d60561c955" # debian 12 (Bookworm) AMI in us-east-1
}

variable "ssh_key_name" {
  description = "Name of the SSH key pair to use for the EC2 instance"
  type        = string
  default     = "~/.ssh/nginx_key.pub" # Replace with your actual key name
}

variable "vpc_id" {
  description = "The ID of the VPC to deploy resources into."
  type        = string
}

variable "public_subnet_id" {
  description = "The ID of the public subnet to deploy resources into."
  type        = string  
}