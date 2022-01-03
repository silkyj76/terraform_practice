/*Internet Gateway
Next we are creating an internet gateway to allow communication between the instances in the VPC and the internet.
We are using aws_vpc.vpc.id in order to get the resource details.

ig.tf*/
resource "aws_vpc" "vpc" {
    cidr_block              = "10.0.0.0/22"
    enable_dns_support      = true
    enable_dns_hostnames    = true

    tags = {
        Name = "Dylan_ECS_VPC"
    }
}

resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "Dylan_ECS_IG"
    }
}

/*Subnet
A subnet is a segment of the VPC’s IP address range where we are launching the instances. I’m creating 2 subnets here, but they are both in a different Availability zone
Please note that both of the cidr_block are also different, you cannot have the same cidr_block for both of those subnet.

subnet.tf*/
resource "aws_subnet" "pub_subnet"{
    vpc_id              = aws_vpc.vpc.id
    cidr_block          = "10.0.1.0/24"
    availability_zone   = "us-east-1b"

    tags = {
        Name = "Dylan_ECS_Subnet_1"
    }
}

resource "aws_subnet" "pub2_subnet"{
    vpc_id              = aws_vpc.vpc.id
    cidr_block          = "10.0.2.0/24"
    availability_zone   = "us-east-1a"

    tags = {
        Name = "Dylan_ECS_Subnet_2"
    }
}

/*Route Table
A route table is a logical construct within a VPC that contains a set of rules (called routes) that applied to the subnet 
and used to determine where network traffic is directed. By entering (0.0.0.0/0) we are creating a route table that will 
direct all traffic to the internet gateway and associate this route table with the subnets that we created earlier.

routetable.tf*/
resource "aws_route_table" "public"{
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }

    tags = {
        Name = "Dylan_ECS_Route_table"
    }
}

resource "aws_route_table_association" "route_table_association"{
    subnet_id       = aws_subnet.pub_subnet.id
    route_table_id  = aws_route_table.public.id
}