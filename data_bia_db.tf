data "aws_secretsmanager_secret" "biadb" {
  arn = aws_db_instance.bia_db.master_user_secret[0].secret_arn
}

