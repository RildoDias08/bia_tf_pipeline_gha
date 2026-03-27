data "aws_iam_policy_document" "ecs_task_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
  
}

resource "aws_iam_policy" "get_secret_biadb" {
  name        = "get-secret-biadb"
  description = "Permissõa que tasks do ECS peguem secrets do Secrets Manager"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = aws_db_instance.bia_db.master_user_secret[0].secret_arn
      }
    ]
  })
  
}

resource "aws_iam_role" "ecs_task_role" {
  name               = "ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_policy" {
  role = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.get_secret_biadb.arn
}