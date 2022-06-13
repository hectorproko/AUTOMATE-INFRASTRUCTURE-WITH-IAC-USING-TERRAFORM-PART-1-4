resource "aws_launch_template" "bastion-launch-template" {
  image_id               = var.ami-bastion
  instance_type          = "t2.micro"
  #vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  vpc_security_group_ids = var.bastion-sg

  iam_instance_profile {
    #name = aws_iam_instance_profile.ip.id
    name = var.instance_profile
  }
  key_name = var.keypair
  placement {
    availability_zone = "random_shuffle.az_list.result"
  }
  lifecycle {
    create_before_destroy = true
  }
  tag_specifications {
    resource_type = "instance"
  tags = merge(
    var.tags,
    {
      Name = format("%s-bastion-template", var.name)
    },
  )
  }
  user_data = filebase64("${path.module}/bastion.sh")
}

# launch template for nginx
resource "aws_launch_template" "nginx-launch-template" {
  image_id               = var.ami-nginx
  instance_type          = "t2.micro"
  #vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  vpc_security_group_ids = var.nginx-sg

  iam_instance_profile {
    #name = aws_iam_instance_profile.ip.id
    name = var.instance_profile
  }
  key_name =  var.keypair
  placement {
    availability_zone = "random_shuffle.az_list.result"
  }
  lifecycle {
    create_before_destroy = true
  }
  tag_specifications {
    resource_type = "instance"

  tags = merge(
    var.tags,
    {
      Name = format("%s-nginx-template", var.name)
    },
  )
  }
  user_data = filebase64("${path.module}/nginx.sh")
}