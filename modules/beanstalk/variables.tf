variable "vpc_id" {
  description = "The ID of the VPC to deploy resources into."
  type        = string
}

variable "public_subnet_id" {
  description = "The ID of the public subnet to deploy resources into."
  type        = string   
}

variable "private_subnet_id" {
  description = "The ID of the private subnet to deploy resources into."
  type        = string
}
