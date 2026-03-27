resource "aws_security_group" "sg_ec2" {
  description = "SG da EC2"
  vpc_id = aws_vpc.this.id
}

resource "aws_vpc_security_group_ingress_rule" "sg_ec2" {
  security_group_id = aws_security_group.sg_ec2.id

  from_port = 0
  to_port = 65535
  ip_protocol = "tcp"
  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_vpc_security_group_egress_rule" "sg_ssm" {
  security_group_id = aws_security_group.sg_ec2.id

  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_security_group" "sg_rds" {

  vpc_id = aws_vpc.this.id
  description = "SG do RDS"
}

resource "aws_vpc_security_group_ingress_rule" "sg_rds" {
  security_group_id = aws_security_group.sg_rds.id
  from_port = 5432
  to_port = 5432
  ip_protocol = "tcp"
  referenced_security_group_id = aws_security_group.sg_ec2.id
}


resource "aws_security_group" "alb" {
  vpc_id = aws_vpc.this.id
  description = "SG do ALB"

  tags = {
    name = "sg_alb"
  }
}
resource "aws_vpc_security_group_ingress_rule" "sg_alb" {
  security_group_id = aws_security_group.alb.id
  for_each = local.portas_alb

  from_port = each.value.port
  to_port = each.value.port
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "sg_alb" {
  security_group_id = aws_security_group.alb.id
  from_port = 0
  to_port = 65535
  ip_protocol = "tcp"
  referenced_security_group_id = aws_security_group.sg_ec2.id
}


