resource "aws_db_instance" "bia_db" {
  identifier = "bia-postgres-db"
  engine = "postgres"
  engine_version = "16"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type = "gp3"
  storage_encrypted = true

  db_name = "bia"
  username = "adminbia"

  db_subnet_group_name = aws_db_subnet_group.db.name
  vpc_security_group_ids = [aws_security_group.sg_rds.id]
  manage_master_user_password = true

  publicly_accessible = false

  backup_retention_period = 0
  multi_az = false 
  skip_final_snapshot = true
  
  tags = {
    Name = "bia-db"
  }
  
}