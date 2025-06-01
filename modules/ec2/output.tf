output "URL_ec2" {
  description = "Public URL of the EC2 instance running Nginx"
  value       = aws_instance.nginx_server.public_dns
}