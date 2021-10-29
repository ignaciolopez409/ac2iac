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
  cidr_block = "172.23.0.0/26"
  tags = {
    Name = "vpc_iac"
  }
}

resource "aws_subnet" "web" {
  cidr_block = "172.23.0.10/29"
  vpc_id = aws_vpc.tarea2.id
}

resource "aws_subnet" "backend" {
  cidr_block = "172.23.0.20/29"
  vpc_id = aws_vpc.tarea2.id
}

resource "aws_subnet" "db" {
  cidr_block = "172.23.0.30/29"
  vpc_id = aws_vpc.tarea2.id
}