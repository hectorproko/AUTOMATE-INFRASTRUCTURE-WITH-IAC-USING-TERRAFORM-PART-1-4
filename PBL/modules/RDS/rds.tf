# This section will create the subnet group for the RDS  instance using the private subnet
resource "aws_db_subnet_group" "HRA-rds" {
  name       = "hra-rds" #│ Error: only lowercase alphanumeric characters, hyphens, underscores, periods, and spaces allowed in "name"
  #subnet_ids = [aws_subnet.private[2].id, aws_subnet.private[3].id]
  subnet_ids = var.private_subnets

 tags = merge(
    var.tags,
    {
      Name = format("%s-rds", var.name)
    },
  )
}

# create the RDS instance with the subnets group
resource "aws_db_instance" "HRA-rds" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "hectordb"
  username               = var.db-username
  password               = var.db-password
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = aws_db_subnet_group.HRA-rds.name
  skip_final_snapshot    = true
  #vpc_security_group_ids = [aws_security_group.datalayer-sg.id]
  vpc_security_group_ids = var.db-sg
  multi_az               = "true"
  depends_on = [aws_db_subnet_group.HRA-rds]
}