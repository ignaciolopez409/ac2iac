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

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_vpc" "tarea2" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc_iac"
  }
}

resource "aws_subnet" "web" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.tarea2.id
  tags = {
    Name = "ac2-web-subnet"
  }
}

resource "aws_subnet" "backend" {
  cidr_block = "10.0.2.0/24"
  vpc_id = aws_vpc.tarea2.id
  tags = {
    Name = "ac2-backend-subnet"
  }
}

resource "aws_subnet" "db" {
  cidr_block = "10.0.3.0/24"
  vpc_id = aws_vpc.tarea2.id
  tags = {
    Name = "ac2-db-subnet"
  }
}