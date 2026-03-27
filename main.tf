resource "aws_vpc" "this" {
    cidr_block = var.vpc_cidr

    tags = {
      Name = "vpc-db"
    }
}

resource "aws_subnet" "public" {
  for_each = var.subnets_public

  vpc_id = aws_vpc.this.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.az
  map_public_ip_on_launch = each.value.public

  tags = {
    Name = each.key
  }
}


resource "aws_subnet" "private" {
  for_each = var.subnets_private

  vpc_id = aws_vpc.this.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.az
  map_public_ip_on_launch = each.value.public

  tags = {
    Name = each.key
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route" "internet" {
  route_table_id = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "subnets_public" {
  for_each = aws_subnet.public

  subnet_id = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "subnets_private" {
  for_each = aws_subnet.private

  subnet_id = each.value.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_db_subnet_group" "db" {
  name = "subnet-group-db"

  subnet_ids = [for s in aws_subnet.private : s.id]
  tags = {
    Name = "subnet-group-db"
  }
}
