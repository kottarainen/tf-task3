output "vpc_id" {
  value = aws_vpc.vpc-task3.id
}

output "security_group_id" {
  value = aws_security_group.allow_http.id
}

output "instance_id" {
  value = aws_instance.ec2-task3.id
}




