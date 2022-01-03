/*In order to successfully complete this lab, we must first have a good understanding of the Terraform state and its 
purpose.In my opinion the state file is most important file. The state file contains everything in your configuration, 
including any secrets you might have defined in them. It is the source of truth for the infrastructure being managed.
Although there are some scenarios where the Terraform may be able to function without a state file, it’s not recommended 
at all.The state is used by Terraform to map real world resources to your configuration, In a nutshell Terraform looks at 
what was already provisioned and track the changes in the state file. It is best practice to store the State file remotely, 
it helps tremendously when working in a team setting. The ideal location for the state file is an S3 bucket when working 
with AWS.*/

//This code will allow Terraform to store the state file in a S3 bucket called “terraformbucketsokito”
terraform{
    backend "s3"{
        bucket  = "dylan-testlab-ou812-private" 
        key     = "terraform.tfstate"
        region  = "us-east-1"
    }
}
//In order to keep my login information safe, I will enter AWS Configure to upload my AWS keys without exposing them.

/*Virtual Private Cloud
First service we will establish is the Virtual Private Cloud.

vpc.tf*/
provider "aws" {
    region = "us-east-1"
}/*We are going to use AWS as a provider for this lab. The resource that we are creating here is a Virtual Private Cloud.
The Virtual private cloud is the networking layer of the EC2, it allows you to build your own virtual network within 
AWS. cidr_block here specifies that IPv4 address range of the VPC.*/

/*Internet Gateway
Next we are creating an internet gateway to allow communication between the instances in the VPC and the internet.
We are using aws_vpc.vpc.id in order to get the resource details.

ig.tf*/
resource "aws_vpc" "vpc" {
    cidr_block              = "10.0.0.0/22"
    enable_dns_support      = true
    enable_dns_hostnames    = true

    tags = {
        Name = "Dylan_VPC_ECS"
    }
}

/*Subnet
A subnet is a segment of the VPC’s IP address range where we are launching the instances. I’m creating 2 subnets here, but they are both in a different Availability zone
Please note that both of the cidr_block are also different, you cannot have the same cidr_block for both of those subnet.

subnet.tf*/
resource "aws_subnet" "public_subnet_1"{
    vpc_id              = aws_vpc.vpc.id
    cidr_block          = "10.0.1.0/24"
    availability_zone   = "us-east-1b"

    tags = {
        Name = "Dylan_Subnet_1_ECS"
    }
}

resource "aws_subnet" "public_subnet_2"{
    vpc_id              = aws_vpc.vpc.id
    cidr_block          = "10.0.2.0/24"
    availability_zone   = "us-east-1a"

    tags = {
        Name = "Dylan_Subnet_2_ECS"
    }
}

/*Route Table
A route table is a logical construct within a VPC that contains a set of rules (called routes) that applied to the subnet 
and used to determine where network traffic is directed. By entering (0.0.0.0/0) we are creating a route table that will 
direct all traffic to the internet gateway and associate this route table with the subnets that we created earlier.

routetable.tf*/

resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "Dylan_IG_ECS"
    }
}

resource "aws_route_table" "public"{
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }

    tags = {
        Name = "Dylan_Route_table_ECS"
    }
}

resource "aws_route_table_association" "route_table_association"{
    subnet_id       = aws_subnet.public_subnet_1.id
    route_table_id  = aws_route_table.public.id
}

resource "aws_eip" "ecs_eip" {
    vpc      = true
    depends_on = [aws_internet_gateway.internet_gateway]     
    
}

resource "aws_nat_gateway" "ecs_nat_gate" {
    allocation_id = aws_eip.ecs_eip.id
    subnet_id = aws_subnet.public_subnet_1.id

    tags = {
      Name = "dylan-ecs-nat-gateway"
    }
  
}

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
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks     = var.cidr_block
    }

    egress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks     = var.cidr_block
    }

    tags = {
        Name = "Dylan_SG_ECS"
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

    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks     = var.cidr_block
    }

    egress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks     = var.cidr_block
    }

    tags = {
        Name = "Dylan_SG_RDS"
    }
}/*The first security group focuses on the EC2 will be stored in the ECS cluster. Inbound traffic is being narrowed to 
two port : 22 for SSH and 443 for HTTPS in order to download the docker image from ECR. The second security group focuses 
on RDS, we have only one port here for MySQL which is 3306. Inbound traffic coming from the internet is open, that’s why 
we have the cidr_block of (0.0.0.0/0). In production environments there should be some limitations within a IP range.
Now with a Security group, Route Table, Subnet and Internet Gateway we are now done with the networking part of the 
architecture.*/

/*resource "aws_alb" "ecs_alb" {
    name                        = "dylan-alb-ecs"
    load_balancer_type          = "application"
    security_groups             = [aws_security_group.ecs_sg.id]
    subnets                     = [ aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id ]
    enable_deletion_protection  = false
    
    tags = {
        Environment = "ecs"
  }
}

resource "aws_alb_target_group" "ecs_tg" {
    name        = "dylan-target-group-ecs"
    port        = 80
    protocol    = "TCP"
    vpc_id      = aws_vpc.vpc.id

    health_check {
      enabled               = true
      healthy_threshold     = 3
      protocol              = "HTTP"
      unhealthy_threshold   = 3
    }
}*/

/*resource "aws_alb_target_group_attachment" "ecs_tga" {
    target_group_arn    = aws_alb_target_group.ecs_tg.arn
    port                = 80
    target_id           = aws_launch_configuration.ecs_launch_config.id
  
}*/

/*resource "aws_alb_listener" "ecs_listener" {
    load_balancer_arn   = aws_alb.ecs_alb.arn
    port                = 80
    protocol            = "HTTP"

    default_action {
      type              = "forward"
      target_group_arn  = aws_alb_target_group.ecs_tg.arn
    }
  
}*/

/*resource "aws_alb_listener_rule" "alb_rule" {
    listener_arn = aws_alb_listener.ecs_listener.arn
    priority = 100

    action {
      type = "forward"
      target_group_arn = aws_alb_target_group.ecs_tg.arn
    }
}*/

resource "aws_elb" "ecs_elb" {
    name                = "dylan-ecs-elb"
    subnets             = [aws_subnet.public_subnet_1.id]
    security_groups     = [aws_security_group.ecs_sg.id]

    cross_zone_load_balancing   = true
    idle_timeout                = 110
    connection_draining         = true
    connection_draining_timeout = 300
    //instances                   = [aws_instance.ecs_instance.id]

    listener {
        instance_port     = 80
        instance_protocol = "tcp"
        lb_port           = 80
        lb_protocol       = "tcp"
    }

    health_check {
        healthy_threshold   = 3
        interval            = 46
        target              = "TCP:80"
        timeout             = 45
        unhealthy_threshold = 3
    }

    tags = {
        Name = "dylan-lb-ecs"
    }
   
}

resource "aws_network_acl" "ecs_acl" {
  vpc_id = aws_vpc.vpc.id
  subnet_ids  = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "10.0.0.0/22"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.0.0.0/22"
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "dylan-acl-ecs"
  }
}

/*Autoscaling group
An Auto Scaling group is a collection of EC2 instances managed by the Auto Scaling Service. Before we launch our 
container instances and register them we have to create an IAM role for those instances.

iam.tf*/
data "aws_iam_policy_document" "ecs_agent"{
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

resource "aws_iam_role" "ecs_agent"{
    name                = "dylan-ecs-agent"
    assume_role_policy  = data.aws_iam_policy_document.ecs_agent.json
}

resource "aws_iam_role_policy_attachment" "ecs_agent" {
    role        = aws_iam_role.ecs_agent.name
    policy_arn  = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_agent"{
    name    = "dylan-iam-ecs-agent2"
    role    = aws_iam_role.ecs_agent.name
}/*Now that we have an IAM role, we can now create an Autoscaling group.
Please note that the AMI being used here is a special one because it comes 
with ECS-optimized image with preinstalled docker and it also falls under the free-tier. */

resource "aws_launch_configuration" "ecs_launch_config"{
    name =  "dylan-ecs-launch-config"
    image_id                = "ami-01783fbb0757adced" //"ami-088052ea36a6c0f83"
    iam_instance_profile    = aws_iam_instance_profile.ecs_agent.name 
    security_groups         = [aws_security_group.ecs_sg.id]
    user_data               = "#!/bin/bash\necho ECS_CLUSTER=my-cluster >> /ect/ecs/ecs.config"
    instance_type           = "t2.micro"
    key_name                = "ecs_key"
    enable_monitoring       = true

    lifecycle {
        create_before_destroy = true
    }
}

//autoscaling.tf
resource "aws_autoscaling_group" "ecs_asg"{
    name                        = "dylan_asg_1"
    vpc_zone_identifier         = [aws_subnet.public_subnet_1.id]
    launch_configuration        = aws_launch_configuration.ecs_launch_config.name 
    desired_capacity            = 2
    max_size                    = 10
    min_size                    = 1
    health_check_grace_period   = 300
    health_check_type           = "EC2"
    load_balancers              = [ aws_elb.ecs_elb.name ]
    //target_group_arns           = [aws_alb_target_group.ecs_tg.arn]

    tag {
        key                 = "Dylan_ECS_instance_1"
        value               = ""
        propagate_at_launch = true
    }

    tag {
        key                 = "Dylan_ECS_instance_2"
        value               = ""
        propagate_at_launch = true
    }

}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name    = aws_autoscaling_group.ecs_asg.id
  elb                       = aws_elb.ecs_elb.id
  //alb_target_group_arn      = aws_alb_target_group.ecs_tg.arn
}

resource "aws_db_subnet_group" "mysql_subnet_group"{
    name        = "dylan-mysql-subnet-group-2"
    subnet_ids  = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

/*Database Instance

Now that we have a subnet and a security group for RDS we need to provision 
database and add both subnets were previously created and then create the actual database instance.

db_subnet.tf*/
resource "aws_db_instance" "mysql2"{
    identifier                  = "dylan-mysql2-ecs"
    allocated_storage           = 5
    backup_retention_period     = 2
    backup_window               = "01:00-01:30"
    maintenance_window          = "sun:03:00-sun:03:30"
    multi_az                    = true
    engine                      = "mysql"
    engine_version              = "5.7"
    instance_class              = "db.t2.micro"
    name                        = "airman_db"
    username                    = "airman"
    password                    = "jedimaster"
    port                        = "3306"
    db_subnet_group_name        = aws_db_subnet_group.mysql_subnet_group.name
    vpc_security_group_ids      = [aws_security_group.rds_sg.id, aws_security_group.ecs_sg.id]
    skip_final_snapshot         = true
    final_snapshot_identifier   = "airman-final"
    publicly_accessible         = true
}

/*Elastic Container Service
Amazon ECS provides a complete container management system supporting Docker containers and windows server containers 
which allows us to use third-party plug-ins and customizations from Kubernetes community.
ECS allows you to setup a cluster of EC2 instances running docker in a selected VPC.
We will use ECR to push the images and use them while launching the EC2 instances within our cluster.*/

//ecr.tf
resource "aws_ecr_repository" "airman"{
    name    = "airman"
    image_tag_mutability  = "MUTABLE"
}

//ecs.tf
resource "aws_ecs_cluster" "ecs_cluster"{
    name = "dylan-cluster-ecs"
}
/*Containers are launched using a task definition. which is a set of simple instructions understood by the ECS cluster. 
Its a JSON file that is kept separately.*/

//template_file.tf
data "template_file" "task_definition_template"{
    template = "${file("${path.module}/task_definition.json.tpl")}" 
    vars = {
        REPOSITORY_URL = replace(aws_ecr_repository.airman.repository_url, "https://992567842996.dkr.ecr.us-east-1.amazonaws.com/airman", "")
    }
}
//We are defining what image will be used using a template variable in the template_file data resource as repository_url.

//task_definition
resource "aws_ecs_task_definition" "task_definition"{
    family                  = "airman"
    container_definitions   = data.template_file.task_definition_template.rendered
}
//ecs.service.tf

resource "aws_ecs_service" "airman" {
  name            = "airman"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn 
  desired_count   = 2

  load_balancer {
    //target_group_arn = aws_alb_target_group.ecs_tg.arn
    elb_name         = aws_elb.ecs_elb.name
    container_name   = "airman"
    container_port   = 80
  }
}

/*data "aws_ecr_image" "airman" {
  repository_name = "airman"
  image_tag       = "latest"
}*/
