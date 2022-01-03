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
    //role        = "aws_iam_role.ecs_agent"
    policy_arn  = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_agent"{
    name    = "ecs-agent"
    role    = aws_iam_role.ecs_agent.name
}/*Now that we have an IAM role, we can now create an Autoscaling group.
Please note that the AMI being used here is a special one because it comes 
with ECS-optimized image with preinstalled docker and it also falls under the free-tier. */

resource "aws_launch_configuration" "ecs_launch_config"{
    image_id                = "ami-088052ea36a6c0f83"
    iam_instance_profile    = aws_iam_instance_profile.ecs_agent.name 
    security_groups         = [aws_security_group.ecs_sg.id]
    user_data               = "#!/bin/bash\necho ECS_CLUSTER=my-cluster >> /ect/ecs/ecs.config"
    instance_type           = "t2.micro"
}
