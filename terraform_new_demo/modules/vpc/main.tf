provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_vpc" "dylan_demo_vpc" {
  cidr_block = var.vpc_cidr
  
  tags = {
    Name = "Dylan_demo_VPC"
  }
}

resource "aws_subnet" "dylan_demo_public_subnet_1" {
  vpc_id            = aws_vpc.dylan_demo_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Dylan_Public_Demo_Subnet_1"
  }
}

resource "aws_subnet" "dylan_demo_public_subnet_2" {
  vpc_id            = aws_vpc.dylan_demo_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Dylan_Public_Demo_Subnet_2"
  }
}

resource "aws_subnet" "dylan_demo_private_subnet_1" {
  vpc_id            = aws_vpc.dylan_demo_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Dylan_Private_Demo_Subnet_1"
  }
}

resource "aws_subnet" "dylan_demo_private_subnet_2" {
  vpc_id            = aws_vpc.dylan_demo_vpc.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Dylan_Private_Demo_Subnet_2"
  }
}

resource "aws_internet_gateway" "dylan_demo_ig" {
  vpc_id = aws_vpc.dylan_demo_vpc.id

  tags = {
    Name = "Dylan_Demo_Internet_Gateway"
  }
}

resource "aws_route_table" "dylan_demo_rt" {
  vpc_id = aws_vpc.dylan_demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dylan_demo_ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.dylan_demo_ig.id
  }

  tags = {
    Name = "Dylan_Demo_Public_Route_Table"
  }
}


resource "aws_route_table_association" "dylan_demo_rt_a" {
  subnet_id      = aws_subnet.dylan_demo_public_subnet_1.id
  route_table_id = aws_route_table.dylan_demo_rt.id
}


