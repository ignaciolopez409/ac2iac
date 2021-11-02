terraform {
  backend "s3" {
    bucket = "ac2-terraform-states"
    key    = "iac/terraform.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_vpc" "ac2iac_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "ac2iac-vpc"
  }
}

resource "aws_internet_gateway" "ac2iac_igw" {
  vpc_id =  aws_vpc.ac2iac_vpc.id
  tags = {
    Name = "ac2iac-igw"
  }
}

resource "aws_subnet" "web" {
  cidr_block = var.front_cdir
  vpc_id = aws_vpc.ac2iac_vpc.id
  map_public_ip_on_launch = true
  tags = {
    Name = "ac2iac-frontend_network"
  }
}

resource "aws_subnet" "backend" {
  cidr_block = var.back_cdir
  vpc_id = aws_vpc.ac2iac_vpc.id
  map_public_ip_on_launch = true
  tags = {
    Name = "ac2iac-backend-network"
  }
}

resource "aws_subnet" "database" {
  cidr_block = var.db_cdir
  vpc_id = aws_vpc.ac2iac_vpc.id
  map_public_ip_on_launch = true
  tags = {
    Name = "ac2iac-database-network"
  }
}

resource "aws_default_route_table" "ac2iac_default_route_table" {
  default_route_table_id = aws_vpc.ac2iac_vpc.default_route_table_id
  route {
    cidr_block = var.ac2iac_rt_cidr_block
    gateway_id = aws_internet_gateway.ac2iac_igw.id
  }
  tags = {
    Name = "ac2iac_default_route_table"
  }
}

resource "aws_route_table_association" "ac2iac_route_table_association_web" {
  subnet_id = aws_subnet.web.id
  route_table_id = aws_default_route_table.ac2iac_default_route_table.id
}

resource "aws_route_table_association" "ac2iac_route_table_association_back" {
  subnet_id = aws_subnet.backend.id
  route_table_id = aws_default_route_table.ac2iac_default_route_table.id
}

resource "aws_route_table_association" "ac2iac_route_table_association_db" {
  subnet_id = aws_subnet.database.id
  route_table_id = aws_default_route_table.ac2iac_default_route_table.id
}

resource "aws_security_group" "outbound_management_and_validation" {
  name = "outbound_managenent_and_validation"
  description = "Security Group que permite acceso 22 para administracion y 80 para validar las instancias"
  vpc_id = aws_vpc.ac2iac_vpc.id
  ingress {
      description = "Management"
      from_port = "22"
      to_port = "22"
      protocol = "tcp"
      cidr_blocks = [var.ac2iac_rt_cidr_block]
  }
  ingress {
      description = "Validation"
      from_port = "80"
      to_port = "80"
      protocol = "tcp"
      cidr_blocks = [var.ac2iac_rt_cidr_block]
    }
  egress {
    description = "Outbound rule"
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [var.ac2iac_rt_cidr_block]
  }
  tags = {
    Name = "Outbound Management and Validation SG"
  }
}

resource "aws_security_group" "ac2iac_front_security_group" {
  description = "Security Group EC2 Frontend Instances"
  vpc_id = aws_vpc.ac2iac_vpc.id
  egress {
    description = "Backend outbound connection"
    from_port = var.application_port
    protocol = "tcp"
    to_port = var.application_port
    cidr_blocks = [var.back_cdir]
  }
}

resource "aws_security_group" "ac2iac_back_security_group" {
  description = "Security Group EC2 Backend Instances"
  vpc_id = aws_vpc.ac2iac_vpc.id
  ingress {
    description = "Frontend inbound connection"
    from_port = var.application_port
    protocol = "tcp"
    to_port = var.application_port
    cidr_blocks = [var.front_cdir]
  }
  egress {
    from_port = var.database_port
    protocol = "tcp"
    to_port = var.database_port
    cidr_blocks = [var.db_cdir]
  }
}

resource "aws_security_group" "ac2iac_db_security_group" {
  description = "Security Group EC2 Database Instances"
  vpc_id = aws_vpc.ac2iac_vpc.id
  ingress {
    description = "Backend inbound connection"
    from_port = var.database_port
    protocol = "tcp"
    to_port = var.database_port
    cidr_blocks = [var.back_cdir]
  }
}