output "ALB-sg" {
#   value = aws_security_group.HRA["${var.name}-ext-ALB"].id
  value = aws_security_group.HRA["ext-alb-sg"].id
}


output "IALB-sg" {
  value = aws_security_group.HRA[format("int-alb-sg")].id
}


output "bastion-sg" {
  value = aws_security_group.HRA[format("bastion-sg")].id
}


output "nginx-sg" {
  value = aws_security_group.HRA[format("nginx-sg")].id
}


output "web-sg" {
  value = aws_security_group.HRA[format("webserver-sg")].id
}


output "datalayer-sg" {
  value = aws_security_group.HRA[format("datalayer-sg")].id
}
