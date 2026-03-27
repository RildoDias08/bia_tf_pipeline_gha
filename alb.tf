resource "aws_lb" "bia_alb" {
  name               = "bia-alb"
  internal           = false
  load_balancer_type = "application"
  
  security_groups    = [aws_security_group.alb.id]
  subnets            = values(aws_subnet.public)[*].id

  tags = {
    Name = "bia-alb"
  } 
}

resource "aws_lb_target_group" "tg_bia" {
  name     = "tg-bia"
  port     = 3001
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = aws_vpc.this.id
  deregistration_delay = 30


  health_check {
    enabled = true
    path = "/api/versao"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 10
    matcher             = "200"
  }  
}

resource "aws_lb_listener" "bia" {
  load_balancer_arn = aws_lb.bia_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

data "aws_acm_certificate" "bia" {
  domain = "*.rio-aws.com.br"
  statuses = ["ISSUED"]
  most_recent = true
}

resource "aws_lb_listener" "bia_https" {
  load_balancer_arn = aws_lb.bia_alb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = data.aws_acm_certificate.bia.arn

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg_bia.arn
  }
  
}
  
