# resource "aws_rds_cluster" "eaas_terraform_database" {
#   count                   = var.rds_setup ? 1 : 0
#   engine                  = "aurora-mysql"
#   db_subnet_group_name    = aws_db_subnet_group.eaas_subnet_group[0].name
#   port                    = var.mysql_port
#   database_name           = var.mysql_db_name
#   master_username         = var.mysql_username
#   master_password         = var.mysql_password
# }
# resource "aws_rds_cluster_instance" "eaas_db_cluster_instances" {
#   count                   = var.rds_setup ? 1 : 0
#   cluster_identifier      = aws_rds_cluster.eaas_terraform_database[0].id
#   instance_class          = "db.t2.medium"
#   engine                  = aws_rds_cluster.eaas_terraform_database[0].engine
#   db_subnet_group_name    = aws_db_subnet_group.eaas_subnet_group[0].name
# }
