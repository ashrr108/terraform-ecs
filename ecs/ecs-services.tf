resource "aws_ecs_service" "roost" {
  name            = "roost"
  cluster         = var.create_cluster ? module.ecs[0].cluster_arn : data.aws_ecs_cluster.selected[0].arn
  task_definition = aws_ecs_task_definition.roost.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = [var.subnets[0]]
    security_groups  = flatten([aws_security_group.roostnginx.*.id])
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.roost.arn
    container_name   = "roost-nginx"
    container_port   = 80
  }

  tags = {
    Project = var.project_name
    Name    = "roost-svc"
  }

  depends_on = [
    aws_ecs_task_definition.roost
  ]
}
