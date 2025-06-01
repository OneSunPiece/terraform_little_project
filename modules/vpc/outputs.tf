output "nexacloud_vpc" {
  description = "The ID of the Nexacloud VPC."
  value       = aws_vpc.nexacloud_vpc.id
}
output "nexacloud_net_public" {
    description = "ID of the public subnet created for Nexacloud"
    value       = aws_subnet.nexacloud_net_public.id
}
output "nexacloud_net_private" {
    description = "ID of the private subnet created for Nexacloud"
    value       = aws_subnet.nexacloud_net_private.id
}
output "nexacloud_igw" {
    description = "ID of the Internet Gateway created for Nexacloud"
    value       = aws_internet_gateway.igw_nexacloud.id
}
output "nexacloud_public_route_table" {
    description = "ID of the public route table created for Nexacloud"
    value       = aws_route_table.public_rt.id
}
