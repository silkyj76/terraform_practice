//autoscaling.tf
resource "aws_autoscaling_group" "failure_analysis_ecs_asg"{
    name                        = "dylan_asg"
    vpc_zone_identifier         = [aws_subnet.pub_subnet.id]
    launch_configuration        = aws_launch_configuration.ecs_launch_config.name 
    desired_capacity            = 2
    max_size                    = 10
    min_size                    = 1
    health_check_grace_period   = 300
    health_check_type           = "EC2"
}

resource "aws_db_subnet_group" "mysql-subnet-group"{
    name        = "dylan-mysql-subnet-group"
    subnet_ids  = [aws_subnet.pub_subnet.id, aws_subnet.pub2_subnet.id]
}