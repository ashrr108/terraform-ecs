

data "aws_iam_policy_document" "ecs_tasks_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskExecutionRole"
}

data "aws_iam_role" "ecs_service_role" {
  name = "AWSServiceRoleForECS"
}

data "aws_iam_role" "ecs_tasks_execution_role" {
  name = var.ecs_task_execution_role_name
}

# resource "aws_iam_role" "ecs_tasks_execution_role" {
#  name               = var.ecs_task_execution_role_name
#  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_execution_role.json
#  tags = {
#    Project = var.project_name
#  }
# }

# resource "aws_iam_role_policy_attachment" "ecs_tasks_execution_role" {
#  role       = aws_iam_role.ecs_tasks_execution_role.name
#  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }

# resource "aws_iam_role_policy_attachment" "cloudwatch" {
#  role       = aws_iam_role.ecs_tasks_execution_role.name
#  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
# }
