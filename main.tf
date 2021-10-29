terraform {
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

backend "s3" {
  bucket = "ac2-terraform-states"
  key    = "iac/terraform.tfstate"
  region = "us-east-1"
}

resource "aws_vpc" "ac2_vpc" {
  cidr_block = "172.23.0.0/26"
  tags {
    Name = "ac2_vpc"
  }
}
