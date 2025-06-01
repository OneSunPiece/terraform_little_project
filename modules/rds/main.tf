resource "aws_rds_cluster" "aurora" {
  cluster_identifier = "my-aurora-cluster"
  engine             = "aurora-postgresql"
  engine_version = "16.6"
  availability_zones = [
    "us-east-1a",
  ]
  database_name           = "mydb"
  master_username         = "postgres" # @todo: Use a secure method to manage secrets (and change this username)
  master_password         = "password" # @todo: Use a secure method to manage secrets (and change this password)
  port                    = 9876
  skip_final_snapshot     = true
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  tags = {
    Name        = "NexacloudAuroraCluster"
  }
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  count              = 1
  identifier         = "my-aurora-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = "db.t4g.small"
  engine             = aws_rds_cluster.aurora.engine
}