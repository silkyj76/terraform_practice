resource "aws_instance" "dylan_demo_ec2" {
  ami                     = var.ami_id
  subnet_id               = var.subnet_id
  iam_instance_profile    = aws_iam_instance_profile.ec2_rofile_dylan.name
  #availability_zone      = ["us-east-1a", "us-east-1b", "us-east-1c"] according to 
      #https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest I don't need it.
  key_name                = var.key_pair
  instance_type           = var.instance_type
  vpc_security_group_ids  = [var.vpc_security_grp_ids]
  security_groups         = [var.security_groups]
  user_data = <<EOF
    #!/bin/bash
    sudo apt update
    sudo apt install -y https://s3.region.amazonaws.com/amazon-ssm-region/latest/linux_amd64/amazon-ssm-agent.rpm
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent
    sudo apt install -y httpd
    systemctl start httpd
    systemctl enable httpd
    cd var/www/html
    echo "<html><body><h1>Deployed via Terraform</h1></body></html>">index.html
    EOF
  tags = {
    Name          = "dylan_demo_ec2"
    t_AppID       = var.t_AppID
    t_dcl         = var.t_dcl
    t_environment = var.t_environment
  }
}

resource "aws_iam_role" "ec2_ssm_role_dylan" {
  name               = "ec2_ssm_role_dylan"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
      "Effect": "Allow",
      "Principal": {"Service": "ssm.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }

  }
   EOF
}

resource "aws_iam_instance_profile" "ec2_rofile_dylan" {
  name = "ec2_profilerofile_dylan"
  role = aws_iam_role.ec2_ssm_role_dylan.name
}

resource "aws_iam_role_policy" "ec2_policy_dylan" {
  name = "ec2_policy_dylan"
  role = aws_iam_role.ec2_ssm_role_dylan.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
