resource "aws_lb" "dylan_demo_alb" {
  internal                   = false
  load_balancer_type         = "application"
  enable_deletion_protection = true
  subnets                    = ["aws_subnet.dylan_demo_public_subnet_1.id", "aws_subnet.dylan_demo_public_subnet_2.id"]

  tags = {
    Name          = "dylan_demo_alb"
  }
}

resource "aws_lb_target_group" "dylan_demo_target_group" {
  name                 = "dylan-demo-target-group"
  port                 = "80"
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  depends_on           = [aws_lb.dylan_demo_alb]
  target_type          = "instance"

  health_check {
    healthy_threshold   = "2"
    unhealthy_threshold = "3"
    matcher             = "301"
    interval            = "30"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "29"
  }
}