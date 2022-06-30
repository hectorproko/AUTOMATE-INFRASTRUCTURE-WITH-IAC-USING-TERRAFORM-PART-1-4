# output "efs-ap-tooling" {
#   description = "Access Point for tooling to .sh script"
#   value       = aws_lb_target_group.nginx-tgt.arn
# }

# output "efs-ap-wordpress" {
#   description = "Access Point for wordpress to .sh script"
#   value       = aws_lb_target_group.nginx-tgt.arn
# }

# "aws_efs_access_point.tooling"
# "aws_efs_access_point.wordpress"

output "efs-test1" {
  description = "Access Point arn"
  value       = aws_efs_access_point.tooling.arn
}
output "efs-test2" {
  description = "Access Point file_system_arn"
  value       = aws_efs_access_point.tooling.file_system_arn
}
output "efs-test3" {
  description = "Access Point file_system_id"
  value       = aws_efs_access_point.tooling.file_system_id
}
output "efs-test4" {
  description = "Access Point id"
  value       = aws_efs_access_point.tooling.id
}
output "efs-test5" {
  description = "Access Point owner_id"
  value       = aws_efs_access_point.tooling.owner_id
}
output "efs-test6" {
  description = "Access Point posix_user"
  value       = aws_efs_access_point.tooling.posix_user
}
output "efs-test7" {
  description = "Access Point root_directory"
  value       = aws_efs_access_point.tooling.root_directory
}
output "efs-test8" {
  description = "Access Point tags"
  value       = aws_efs_access_point.tooling.tags
}
output "efs-test9" {
  description = "Access Point tags_all"
  value       = aws_efs_access_point.tooling.tags_all   
}