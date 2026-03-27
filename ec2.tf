data "aws_ami" "amz_lnx" {
  most_recent = true 
  owners = [ "amazon" ]

  filter {
    name = "name"
    values = [ "amzn2-ami-hvm-*-x86_64-*" ]
  }
}

resource "aws_launch_template" "bia_dev" {
  name_prefix = "bia-template"
  image_id = data.aws_ami.amz_lnx.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.sg_ec2.id]
  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_profile.arn
  }

  tags = {
    Name = "bia-template"
  }

}

resource "aws_instance" "bia_dev" {
  subnet_id = values(aws_subnet.public)[0].id
  user_data = file("user_data_ec2.sh")
  user_data_replace_on_change = true

  launch_template {
    id = aws_launch_template.bia_dev.id
    version = "$Latest"
  }

  tags = {
    Name = "bia-dev"
  }

}