output "rds-test1" {
  description = "RDS address"
  value       = aws_db_instance.HRA-rds.address
}
output "rds-test2" {
  description = "RDS endpoint"
  value       = aws_db_instance.HRA-rds.endpoint
}

# address - The hostname of the RDS instance. See also endpoint and port.
# endpoint - The connection endpoint in address:port format.

