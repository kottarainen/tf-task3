terraform {
  required_providers {
    aws = {
      version = "~> 3.76.1"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_vpc" "vpc-task3" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-task3"
  }
}

resource "aws_internet_gateway" "ig-task3" {
  vpc_id = aws_vpc.vpc-task3.id
  tags = {
    Name = "ig-task3"
  }
}

#create public subnet
resource "aws_subnet" "publicsubnet-task3" {
  vpc_id                  = aws_vpc.vpc-task3.id
  map_public_ip_on_launch = true
  cidr_block              = "10.0.1.0/24"
  tags = {
    Name = "publicsubnet-task3"
  }

}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc-task3.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig-task3.id
  }
  tags = {
    Name = "Public Route Table"
  }
}

#associate public subnet to public route table

resource "aws_route_table_association" "public-subnet-1-route-table-association" {
  subnet_id      = aws_subnet.publicsubnet-task3.id
  route_table_id = aws_route_table.public-route-table.id
}



resource "aws_instance" "ec2-task3" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = ["${aws_security_group.allow_http.id}"]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.publicsubnet-task3.id

  user_data = file("${path.module}/userdata.tpl")

  tags = {
    Name = "ec2-task3"
  }
  key_name = "keys-task3"


}

