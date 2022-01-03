output "vpc_id"{
  value = aws_vpc.dylan_demo_vpc.id
}

output "public_subnet_1" {
  value = aws_subnet.dylan_demo_public_subnet_1.id
}

output "public_subnet_2" {
  value = aws_subnet.dylan_demo_public_subnet_2.id
}

/*output "private_subnet_1" {
  value = aws_subnet.dylan_demo_private_subnet_1.id
}

output "private_subnet_2" {
  value = aws_subnet.dylan_demo_private_subnet_2.id
}*/