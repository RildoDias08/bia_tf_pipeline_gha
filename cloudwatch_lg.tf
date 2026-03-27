resource "aws_cloudwatch_log_group" "ecs_bia" {
  name = "/ecs/bia"
  retention_in_days = 7
}