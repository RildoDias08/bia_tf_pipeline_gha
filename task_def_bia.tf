resource "aws_ecs_task_definition" "bia" {
  family = "task-def-bia"
  network_mode = "bridge"
  task_role_arn = aws_iam_role.ecs_task_role.arn
  
  container_definitions = jsonencode([
    {
      name = "bia",
      image = "${aws_ecr_repository.bia_repo.repository_url}:latest",
      memory = 512,
      cpu = 1024,
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort = 0
        }
      ]
      environment = [
        {name = "DB_PORT", value = "5432"},
        {name = "DB_HOST",value = "${aws_db_instance.bia_db.address}"},
        {name = "DB_SECRET_NAME", value = "${data.aws_secretsmanager_secret.biadb.name}"},
        {name = "DB_REGION", value = "us-east-1"}, 
        {name = "DEBUG-SECRET", value = "true"}
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group" = aws_cloudwatch_log_group.ecs_bia.name
          "awslogs-region" = "us-east-1"
          "awslogs-stream-prefix" = "bia"
        }
      }
    }
  ])

  runtime_platform {
    cpu_architecture = "X86_64"
    operating_system_family = "LINUX"
  }
}