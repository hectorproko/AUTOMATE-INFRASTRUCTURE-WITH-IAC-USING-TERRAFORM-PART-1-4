# creating dynamic ingress security groups
locals {
  security_groups = {
    ext-alb-sg = {
      name        = format("%s-ext-ALB", var.name)
      description = "for external loadbalncer"
    }
    # security group for bastion
    bastion-sg = {
      name        = format("%s-bastion", var.name)
      description = "for bastion instances"
    }
    # security group for nginx
    nginx-sg = {
      name        = format("%s-nginx-reverse-proxy", var.name)
      description = "nginx instances"
    }
    # security group for IALB
    int-alb-sg = {
      name        = format("%s-int-ALB", var.name)
      description = "IALB security group"
    }
    # security group for webservers
    webserver-sg = {
      name        = format("%s-webserver", var.name)
      description = "webservers security group"
    }
    # security group for data-layer
    datalayer-sg = {
      name        = format("%s-datalayer", var.name)
      description = "data layer security group"
    }
  }
}