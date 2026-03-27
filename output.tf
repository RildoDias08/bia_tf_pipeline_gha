output "rds_endpoint" {
  description = "RDS endpoint"
  value = aws_db_instance.bia_db.endpoint
}

output "alb_dns" {
  value = aws_lb.bia_alb.dns_name
}

output "repo_url" {
  value = aws_ecr_repository.bia_repo.repository_url
}

output "instance_id" {
  value = aws_instance.bia_dev.id
}

output "ip_instance" {
  value = aws_instance.bia_dev.public_ip
}

output "secret_name" {
  value = data.aws_secretsmanager_secret.biadb.name
}
