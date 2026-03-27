resource "aws_autoscaling_group" "ecs_asg" {
  name                      = "ecs-asg"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 2

  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }

  vpc_zone_identifier       = [for subnet in aws_subnet.public : subnet.id]
  health_check_type         = "EC2"
  health_check_grace_period = 0
  protect_from_scale_in = false

  tag {
    key = "Name"
    value = "cluster-bia"
    propagate_at_launch = true
  }

  tag {
    key = "AmazonECSManaged"
    value = ""
    propagate_at_launch = true
  }
}