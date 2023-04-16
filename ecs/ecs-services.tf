resource "aws_ecs_service" "roostnginx" {
  name            = "roostnginx"
  cluster         = var.create_cluster ? module.ecs[0].cluster_arn : data.aws_ecs_cluster.selected[0].arn
  task_definition = aws_ecs_task_definition.roostnginx.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = [var.subnets[0]]
    security_groups  = flatten([aws_security_group.roostnginx.*.id])
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.roostnginx.arn
    container_name   = "roostnginx"
    container_port   = 80
  }


  tags = {
    Project = var.project_name
    Name    = "roostnginx-svc"
  }

  depends_on = [
    aws_ecs_task_definition.roostnginx,
    aws_ecs_service.roostweb,
    aws_ecs_service.roostapp

  ]
}


resource "aws_service_discovery_private_dns_namespace" "roostns" {
  name        = "roostns"
  description = "namespace for roost services"
  vpc         = data.aws_vpc.selected.id
}




resource "aws_ecs_service" "roostweb" {
  name            = "roost-web"
  cluster         = var.create_cluster ? module.ecs[0].cluster_arn : data.aws_ecs_cluster.selected[0].arn
  task_definition = aws_ecs_task_definition.roostweb.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets = [var.subnets[0]]
    # security_groups  = flatten([aws_security_group.webroost.*.id])
    security_groups  = flatten([aws_security_group.roostnginx.*.id])
    assign_public_ip = true
  }

  service_registries  {
    registry_arn = aws_service_discovery_service.roostweb.arn
  }


  tags = {
    Project = var.project_name
    Name    = "roostweb-svc"
  }

  depends_on = [
    aws_ecs_task_definition.roostweb,
  ]
}

resource "aws_service_discovery_service" "roostweb" {
  name = "roostweb"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.roostns.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}


resource "aws_ecs_service" "roostapp" {
  name            = "roost-app"
  cluster         = var.create_cluster ? module.ecs[0].cluster_arn : data.aws_ecs_cluster.selected[0].arn
  task_definition = aws_ecs_task_definition.roostapp.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets = [var.subnets[0]]
    # security_groups  = flatten([aws_security_group.approost.*.id])
    security_groups  = flatten([aws_security_group.roostnginx.*.id])
    assign_public_ip = true
  }
  service_registries  {
    registry_arn = aws_service_discovery_service.roostapp.arn
  }

  tags = {
    Project = var.project_name
    Name    = "roostapp-svc"
  }

  depends_on = [
    aws_ecs_task_definition.roostapp
  ]
}

resource "aws_service_discovery_service" "roostapp" {
  name = "roostapp"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.roostns.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}


resource "aws_ecs_service" "roosteaas" {
  name            = "roost-eaas"
  cluster         = var.create_cluster ? module.ecs[0].cluster_arn : data.aws_ecs_cluster.selected[0].arn
  task_definition = aws_ecs_task_definition.roosteaas.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets = [var.subnets[0]]
    # security_groups  = flatten([aws_security_group.releaseserver.*.id])
    security_groups  = flatten([aws_security_group.roostnginx.*.id])
    assign_public_ip = true
  }
  service_registries  {
    registry_arn = aws_service_discovery_service.roosteaas.arn
  }

  tags = {
    Project = var.project_name
    Name    = "roosteaas-svc"
  }

  depends_on = [
    aws_ecs_task_definition.roosteaas
  ]
}

resource "aws_service_discovery_service" "roosteaas" {
  name = "roosteaas"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.roostns.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}



