resource "aws_ecs_service" "service_bia" {
  name            = "service-bia"
  cluster         = aws_ecs_cluster.cluster_bia.name
  task_definition = aws_ecs_task_definition.bia.arn
  desired_count   = 2

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.bia.name
    base = 1
    weight = 100
  }

  ordered_placement_strategy {
    type = "spread"
    field = "attribute:ecs.availability-zone"
  }

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent = 100

  depends_on = [ aws_lb_target_group.tg_bia ]


  load_balancer {
    target_group_arn = aws_lb_target_group.tg_bia.arn
    container_name   = "bia"
    container_port   = 8080
  }
  
}