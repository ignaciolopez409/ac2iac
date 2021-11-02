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
    Name = "ac2iac_vpc"
  }
}

resource "aws_internet_gateway" "ac2iac_igw" {
  vpc_id =  aws_vpc.ac2iac_vpc.id
  tags = {
    Name = "ac2iac_igw"
  }
}

resource "aws_subnet" "web" {
  cidr_block = var.front_cdir
  vpc_id = aws_vpc.ac2iac_vpc.id
  map_public_ip_on_launch = true
  tags = {
    Name = "frontend_network"
  }
}

resource "aws_subnet" "backend" {
  cidr_block = var.back_cdir
  vpc_id = aws_vpc.ac2iac_vpc.id
  map_public_ip_on_launch = true
  tags = {
    Name = "backend-network"
  }
}

resource "aws_subnet" "database" {
  cidr_block = var.db_cdir
  vpc_id = aws_vpc.ac2iac_vpc.id
  map_public_ip_on_launch = true
  tags = {
    Name = "database-network"
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

resource "aws_route_table_association" "ac2iac_route_table_association" {
  subnet_id = [aws_subnet.web.id, aws_subnet.backend.id, aws_subnet.database.id]
  route_table_id = aws_default_route_table.ac2iac_default_route_table.id
}