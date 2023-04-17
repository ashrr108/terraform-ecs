resource "aws_cloudwatch_log_group" "roost" {
  name_prefix = "/roost/ecs/"

  tags = {
    Project = var.project_name
    Name = "roost-log-group"
  }
}
