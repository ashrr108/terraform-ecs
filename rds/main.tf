
provider "aws" {
  region = local.region
}

locals {
  region = var.region
}

resource "random_password" "password" {
  length = 16
  lower  = false

  lifecycle {
    ignore_changes = [
      length,
      lower,
    ]
  }
}

module "db" {

  source = "terraform-aws-modules/rds/aws"

  identifier = "roost"

  engine            = "mysql"
  engine_version    = "8.0.23"
  instance_class    = "db.r6g.large"
  allocated_storage = 5
  # allocated_storage = 50

  publicly_accessible = true

  # storage_type = "gp3"


  db_name                = "roostio"
  username               = var.user
  port                   = var.port
  create_random_password = false
  password               = var.password

  iam_database_authentication_enabled = true

  # vpc_security_group_ids = flatten([var.vpc_security_group_ids])
  vpc_security_group_ids = var.vpc_security_group_ids

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["audit", "general"]

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

  # Enhanced monitoring
  monitoring_interval = 30
  monitoring_role_arn = aws_iam_role.rds_enhanced_monitoring.arn

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  # create_monitoring_role                = true

  tags = {
    Project = var.project_name
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = var.subnets

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"


  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  # options = [
  #   {
  #     option_name = "MARIADB_AUDIT_PLUGIN"

  #     option_settings = [
  #       {
  #         name  = "SERVER_AUDIT_EVENTS"
  #         value = "CONNECT"
  #       },
  #       {
  #         name  = "SERVER_AUDIT_FILE_ROTATIONS"
  #         value = "37"
  #       },
  #     ]
  #   },
  # ]
}


################################################################################
# Create an IAM role to allow enhanced monitoring
################################################################################

resource "aws_iam_role" "rds_enhanced_monitoring" {
  name_prefix        = "rds-enhanced-monitoring-"
  assume_role_policy = data.aws_iam_policy_document.rds_enhanced_monitoring.json
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  role       = aws_iam_role.rds_enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

data "aws_iam_policy_document" "rds_enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}
