/*Security Group
A security group serves as a virtual stateful firewall that controls inbound and outbound network traffic to AWS resources 
and Amazon EC2 instances. Please note that we are already allowing traffic from the internet to and from the VPC. We have 
to set some rules in order to secure the instances. The two instances that we will create today are an EC2 and RDS MySQL. 
In this case we are going to need two security groups.

sg.tf*/
resource "aws_security_group" "ecs_sg"{
    vpc_id      = aws_vpc.vpc.id

    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks     = var.cidr_block
    }
    
    ingress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = var.cidr_block
    }

    egress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        cidr_blocks     = var.cidr_block
    }

    tags = {
        Name = "Dylan_ECS_SG"
    }
}

resource "aws_security_group" "rds_sg" {
    vpc_id      = aws_vpc.vpc.id

    ingress {
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        cidr_blocks     = var.cidr_block
        security_groups = [aws_security_group.ecs_sg.id]
    }

    egress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        cidr_blocks     = var.cidr_block
    }

    tags = {
        Name = "Dylan_RDS_SG"
    }
}/*The first security group focuses on the EC2 will be stored in the ECS cluster. Inbound traffic is being narrowed to 
two port : 22 for SSH and 443 for HTTPS in order to download the docker image from ECR. The second security group focuses 
on RDS, we have only one port here for MySQL which is 3306. Inbound traffic coming from the internet is open, that’s why 
we have the cidr_block of (0.0.0.0/0). In production environments there should be some limitations within a IP range.
Now with a Security group, Route Table, Subnet and Internet Gateway we are now done with the networking part of the 
architecture.*/