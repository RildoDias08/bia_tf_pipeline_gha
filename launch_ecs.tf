data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2023/recommended/image_id"
}

resource "aws_launch_template" "ecs" {
  name_prefix = "ecs-bia"

  image_id = data.aws_ssm_parameter.ecs_ami.value
  vpc_security_group_ids = [aws_security_group.sg_ec2.id]

  instance_type = "t3.micro"
  iam_instance_profile {
    arn = aws_iam_instance_profile.ecs_profile.arn
  }

  monitoring {
    enabled = false
  }

  user_data = base64encode(<<-EOF
#!/bin/bash
cat <<EOT >> /etc/ecs/ecs.config
ECS_CLUSTER=${aws_ecs_cluster.cluster_bia.name}
EOT
EOF
)

  tags = {
    Name = "ecs-bia-tf"
  }
}