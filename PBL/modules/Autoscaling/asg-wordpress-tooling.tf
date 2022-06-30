
# ---- Autoscaling for wordpress application
resource "aws_autoscaling_group" "wordpress-asg" {
  name                      = format("%s-wordpress", var.name)
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = var.desired_capacity
  #vpc_zone_identifier = [aws_subnet.private[0].id,aws_subnet.private[1].id]
  vpc_zone_identifier = var.private_subnets
  launch_template {
    id      = aws_launch_template.wordpress-launch-template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = format("%s-wordpress", var.name)
    propagate_at_launch = true
  }
}

# attaching autoscaling group of  wordpress application to internal loadbalancer
resource "aws_autoscaling_attachment" "asg_attachment_wordpress" {
  autoscaling_group_name = aws_autoscaling_group.wordpress-asg.id
  alb_target_group_arn   = var.wordpress-alb-tgt
  #alb_target_group_arn   = aws_lb_target_group.wordpress-tgt.arn
}

# ---- Autoscaling for tooling -----
resource "aws_autoscaling_group" "tooling-asg" {
  name                      = format("%s-tooling", var.name)
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = var.desired_capacity
  #vpc_zone_identifier = [aws_subnet.private[0].id,aws_subnet.private[1].id]
  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.tooling-launch-template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = format("%s-tooling", var.name)
    propagate_at_launch = true
  }
}

# attaching autoscaling group of  tooling application to internal loadbalancer
resource "aws_autoscaling_attachment" "asg_attachment_tooling" {
  autoscaling_group_name = aws_autoscaling_group.tooling-asg.id
  #alb_target_group_arn   = aws_lb_target_group.tooling-tgt.arn
  alb_target_group_arn   = var.tooling-alb-tgt
}