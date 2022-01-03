resource "aws_security_group" "dylan_demo_sg" {
  name        = "dylan_demo_sg"
  description = "allow access on port 8080"
  vpc_id      = var.vpc_id
  tags = {
    Name          = "dylan_demo_sg"
    /*t_AppID       = var.t_AppID
    t_dcl         = var.t_dcl
    t_environment = var.t_environment*/
  }
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}