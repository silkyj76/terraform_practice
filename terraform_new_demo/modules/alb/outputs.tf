output "target_group_name" {
  value = aws_lb_target_group.dylan_demo_target_group.name
}

output "target_group_arn" {
  value = aws_lb_target_group.dylan_demo_target_group.arn
}

output "alb_load_balancer" {
  value = aws_lb.dylan_demo_alb.id
}