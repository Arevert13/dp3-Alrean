resource "aws_vpc" "vpc_ord_thinker" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "ordinal-thinker-vpc"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.vpc_ord_thinker.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "ordinal-thinker-private-subnet-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.vpc_ord_thinker.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "ordinal-thinker-private-subnet-2"
  }
}

resource "aws_security_group" "rds_sg" {
  name   = "ordinal-thinker-rds-sg"
  vpc_id = aws_vpc.vpc_ord_thinker.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Cambiar si se requiere más seguridad
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "rds_subnets" {
  name       = "ordinal-thinker-db-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}