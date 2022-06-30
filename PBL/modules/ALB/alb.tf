#External Load Balancer for reverse proxy nginx
resource "aws_lb" "ext-alb" {
    name     = format("%s-ext-ALB", var.name) #<<<
    internal = false
    #security_groups = [aws_security_group.ext-alb-sg.id,]
    security_groups = [var.public-sg]

    #subnets = [aws_subnet.public[0].id,aws_subnet.public[1].id]
    subnets = [var.public-sbn-1,var.public-sbn-2, ]

    tags = merge(
        var.tags,
        {
            Name = format("%s-ext-ALB", var.name)
        },
    )
    #ip_address_type    = "ipv4"
    ip_address_type    = var.ip_address_type
    #load_balancer_type = "application"
    load_balancer_type = var.load_balancer_type
}
#--- create a target group for the external load balancer
# Could turn all hardcoded attributes to variables
resource "aws_lb_target_group" "nginx-tgt" {
    health_check {
        interval            = 10
        path                = "/healthstatus"
        protocol            = "HTTPS"
        timeout             = 5
        healthy_threshold   = 5
        unhealthy_threshold = 2
    }
    name        = format("%s-nginx-target", var.name) 
    port        = 443
    protocol    = "HTTPS"
    target_type = "instance"
    #vpc_id      = aws_vpc.main.id
    vpc_id      = var.vpc_id
    tags = merge(
        var.tags,
        {
            Name = format("%s-nginx-target", var.name) 
        },
    )
}
#create a listener for the load balancer
resource "aws_lb_listener" "nginx-listner" {
    load_balancer_arn = aws_lb.ext-alb.arn
    port              = 443
    protocol          = "HTTPS"
    certificate_arn   = aws_acm_certificate_validation.hracompany.certificate_arn
    depends_on = [aws_lb_target_group.nginx-tgt]
    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.nginx-tgt.arn
    }
}



####### Internal Load Balancers #######
# for webserrvers
resource "aws_lb" "ialb" {
  name     = format("%s-int-ALB", var.name)
  internal = true
  #security_groups = [aws_security_group.int-alb-sg.id,]
  security_groups = [var.private-sg]

  #subnets = [aws_subnet.private[0].id, aws_subnet.private[1].id]
  subnets = [var.private-sbn-1, var.private-sbn-2,]
  
  tags = merge(
    var.tags,
    {
      Name = format("%s-int-ALB", var.name)
    },
  )
  #ip_address_type    = "ipv4"
  ip_address_type    = var.ip_address_type
  #load_balancer_type = "application"
  load_balancer_type = var.load_balancer_type
}

# --- target group  for wordpress -------
resource "aws_lb_target_group" "wordpress-tgt" {
  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
  name        = format("%s-wordpress-target", var.name)
  port        = 443
  protocol    = "HTTPS"
  target_type = "instance"
  #vpc_id      = aws_vpc.main.id
  vpc_id      = var.vpc_id
  tags = merge(
    var.tags,
    {
      Name = format("%s-wordpress-target", var.name)
    },
  )
}
# --- target group for tooling -------
resource "aws_lb_target_group" "tooling-tgt" {
  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
  name        = format("%s-tooling-target", var.name)
  port        = 443
  protocol    = "HTTPS"
  target_type = "instance"
  #vpc_id      = aws_vpc.main.id
  vpc_id      = var.vpc_id
  tags = merge(
    var.tags,
    {
      Name = format("%s-tooling-target", var.name)
    },
  )
}

# For this aspect a single listener was created for the wordpress which is default,
# A rule was created to route traffic to tooling when the host header changes
resource "aws_lb_listener" "web-listener" {
  load_balancer_arn = aws_lb.ialb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.hracompany.certificate_arn
  depends_on = [aws_lb_target_group.wordpress-tgt]
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress-tgt.arn
  }
}

# listener rule for tooling target
resource "aws_lb_listener_rule" "tooling-listener" {
  listener_arn = aws_lb_listener.web-listener.arn
  priority     = 99
  depends_on = [aws_lb_target_group.tooling-tgt]
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tooling-tgt.arn
  }
  condition {
    host_header {
      values = ["tooling.hracompany.ga"]
    }
  }
}
