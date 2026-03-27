data "aws_iam_policy_document" "ecs_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
  
}

resource "aws_iam_role" "ecs_role" {
  name               = "ecs-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_ssm" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_profile" {
  name = "ecs-profile"
  role = aws_iam_role.ecs_role.name
}
