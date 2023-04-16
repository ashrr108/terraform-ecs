output "rds_arn" {
  value = module.db.db_instance_arn
}
output "rds_address" {
  value = module.db.db_instance_address
}

output "rds_port" {
  value = module.db.db_instance_port
}

output "rds_user" {
  value = var.user
}
