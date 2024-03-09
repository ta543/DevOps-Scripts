
output "db-password" {
  value       = aws_db_instance.db.password
  description = "Password for database"
  sensitive   = true # won't be output in Terminal but will be in state file
}
