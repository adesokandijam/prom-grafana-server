#networking/main.tf

data "aws_availability_zones" "available" {}

resource "aws_vpc" "main_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
}

resource "aws_subnet" "private_subnet" {
  count                   = var.private_sn_count
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.private_subnet_cidr[count.index]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[count.index]
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_default_route_table" "main_private_rt" {
  default_route_table_id = aws_vpc.main_vpc.default_route_table_id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id
}

resource "aws_route_table_association" "public_assoc" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "all_sg" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.main_vpc.id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "lb_sg" {
  name        = "alb_sg"
  description = "Allow HTTP connection"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description      = "HHTPS from public"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "lb_sg_http" {
  name        = "alb_sg_http"
  description = "Allow HTTP connection"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description      = "HHTP from public"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "server_sg" {
  name        = "server_sg"
  description = "connection of server and lb"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description      = "port 3000 from lb"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}


