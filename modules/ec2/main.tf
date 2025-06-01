resource "aws_instance" "nginx_server" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.deployer.key_name     # Use the key pair created above
  subnet_id                   = var.public_subnet_id # Use the public subnet for internet access
  associate_public_ip_address = true                               # Assign a public IP for internet accessibility
  vpc_security_group_ids      = [aws_security_group.app_sg.id]     # Attach the security group

  # User Data to install Nginx and start the service on launch
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install nginx1 -y # For Amazon Linux 2 (use `sudo dnf install nginx -y` for AL2023)
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Welcome to your Nginx server deployed by Terraform!</h1>" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name        = "NginxServer"
    Environment = "Development"
  }
}

# Security Group for Nginx Server
resource "aws_security_group" "app_sg" {
  name_prefix = "nginx-server-sg-"
  description = "Allow HTTP/HTTPS inbound traffic and all outbound traffic for Nginx"
  vpc_id      = var.vpc_id

  // Ingress (Inbound) Rules
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # WARNING: 0.0.0.0/0 allows traffic from anywhere. Restrict in production!
    description = "Allow HTTP traffic from anywhere"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # WARNING: 0.0.0.0/0 allows traffic from anywhere. Restrict in production!
    description = "Allow HTTPS traffic from anywhere"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # WARNING: 0.0.0.0/0 allows SSH from anywhere. Restrict to your IP!
    description = "Allow SSH traffic from anywhere"
  }

  // Egress (Outbound) Rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "nginx-server-sg"
  }
}
# Key Pair for SSH Access
resource "aws_key_pair" "deployer" {
  key_name   = "nginx-key-pair"
  public_key = file(var.ssh_key_name) # Path to your public key
}
