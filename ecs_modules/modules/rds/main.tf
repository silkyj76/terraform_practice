
/*Database Instance

Now that we have a subnet and a security group for RDS we need to provision 
database and add both subnets were previously created and then create the actual database instance.

db_subnet.tf*/
resource "aws_db_instance" "mysql"{
    identifier                  = "dylan-mysql"
    allocated_storage           = 5
    backup_retention_period     = 2
    backup_window               = "01:00-01:30"
    maintenance_window          = "sun:03:00-sun:03:30"
    multi_az                    = true
    engine                      = "mysql"
    engine_version              = "5.7"
    instance_class              = "db.t2.micro"
    name                        = "worker_db"
    username                    = "worker"
    password                    = "jedimaster"
    port                        = "3306"
    db_subnet_group_name        = aws_db_subnet_group.mysql-subnet-group.name
    vpc_security_group_ids      = [aws_security_group.rds_sg.id, aws_security_group.ecs_sg.id]
    skip_final_snapshot         = true
    final_snapshot_identifier   = "worker-final"
    publicly_accessible         = true
}