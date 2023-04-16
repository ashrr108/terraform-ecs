resource "aws_ecs_task_definition" "roostnginx" {
  family                   = "roostnginx"
  execution_role_arn       = "${data.aws_iam_role.ecs_tasks_execution_role.arn}"
  task_role_arn            = "${data.aws_iam_role.ecs_tasks_execution_role.arn}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name      = "roostnginx"
      image     = "${var.NGINX_IMG}:${var.NGINX_VER}"
      cpu       = tonumber(1024)
      memory    = tonumber(2048)
      essential = true
      portMappings = [
        {
          name          = "port-80"
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = aws_cloudwatch_log_group.roost.name
          awslogs-region        = "${data.aws_region.current.name}"
          awslogs-stream-prefix = "roostnginx-container"
        }
      }
    },
  ])
}



resource "aws_ecs_task_definition" "roostweb" {
  family                   = "roost-web"
  execution_role_arn       = "${data.aws_iam_role.ecs_tasks_execution_role.arn}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 2048
  memory                   = 4096
  container_definitions = jsonencode([
    {
      name      = "roost-web"
      image     = "${var.UI_IMG}:${var.UI_VER}"
      cpu       = tonumber(2048)
      memory    = tonumber(4096)
      essential = true
      portMappings = [
        {
          name          = "port-4200"
          containerPort = 4200
          hostPort      = 4200
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      environment = [
        {
          "name" : "REACT_APP_ENTERPRISE_LOGO",
          "value" : "${var.enterprise_logo}"
        },
        {
          "name" : "REACT_APP_IS_DEPLOYED_IN_ECS",
          "value" : "true"
        },
        {
          "name" : "REACT_APP_COOKIE_SECURE",
          "value" : "true"
        },
        {
          "name" : "REACT_APP_COOKIE_DOMAIN",
          "value" : "${var.enterprise_dns}"
        },
        {
          "name" : "REACT_APP_REMOTE_CONSOLE_PROXY",
          "value" : "https://${var.enterprise_dns}"
        },
        {
          "name" : "REACT_APP_OKTA_CLIENT_ISSUER",
          "value" : "${var.okta_client_issuer}"
        },
        {
          "name" : "REACT_APP_OKTA_CLIENT_ID",
          "value" : "${var.okta_client_id}"
        },
        {
          "name" : "REACT_APP_AZURE_CLIENT_ID",
          "value" : "${var.azure_client_id}"
        },
        {
          "name" : "REACT_APP_REDIRECT_URI",
          "value" : "https://${var.enterprise_dns}/login"
        },
        {
          "name" : "REACT_APP_API_HOST",
          "value" : "https://${var.enterprise_dns}/api"
        },
        {
          "name" : "REACT_APP_ROOST_VER",
          "value" : "${var.roost_version}"
        },
        {
          "name" : "REACT_APP_DB_VER",
          "value" : "v1.1.0"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = aws_cloudwatch_log_group.roost.name
          awslogs-region        = "${data.aws_region.current.name}"
          awslogs-stream-prefix = "webroost-container"
        }
      }
    },
  ])
}


resource "aws_ecs_task_definition" "roostapp" {
  family                   = "roost-app"
  execution_role_arn       = "${data.aws_iam_role.ecs_tasks_execution_role.arn}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 4096
  memory                   = 8192
  container_definitions = jsonencode([
    {
      name      = "roost-app"
      image     = "${var.SERVER_IMG}:${var.SERVER_VER}"
      cpu       = tonumber(2048)
      memory    = tonumber(4096)
      essential = true
      portMappings = [
        {
          name          = "port-3000"
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      environment = [
        {
          "name" : "DEFAULT_PORT",
          "value" : "3000"
        },
        {
          "name" : "JUMPHOST_SVC",
          "value" : "127.0.0.1"
        },
        {
          "name" : "EAAS_SVC",
          "value" : "roosteaas.roostns"
        },
        {
          "name" : "JWT_SECRET",
          "value" : "32-character-secure-long-secret"
        },
        {
          "name" : "NODE_ENV",
          "value" : "production"
        },
        {
          "name" : "MYSQL_DB_NAME",
          "value" : "${var.dbname}"
        },
        {
          "name" : "LOCAL_AUTH_KEY",
          "value" : "LocalKey/${var.roost_local_key}"
        },
        {
          "name" : "LOGIN_REDIRECT_URL",
          "value" : "https://${var.enterprise_dns}/login"
        },
        {
          "name" : "API_HOST_URL",
          "value" : "https://${var.enterprise_dns}/api"
        },
        {
          "name" : "ORG_ADMIN_EMAIL",
          "value" : "${var.admin_email}"
        },
        {
          "name" : "ORG_NAME",
          "value" : "${var.company_name}"
        },
        {
          "name" : "ORG_APP_NAME",
          "value" : "default"
        },
        {
          "name" : "MYSQL_USERNAME",
          "value" : "${var.mysql_user}"
        },
        {
          "name" : "MYSQL_PASSWORD",
          "value" : "${var.mysql_password}"
        },
        {
          "name" : "MYSQL_HOST",
          "value" : "${var.mysql_host}"
        },
        {
          "name" : "MYSQL_PORT",
          "value" : "${var.mysql_port}"
        },
        {
          "name" : "OKTA_CLIENT_ID",
          "value" : "${var.okta_client_id}"
        },
        {
          "name" : "OKTA_CLIENT_SECRET",
          "value" : "${var.okta_client_secret}"
        },
        {
          "name" : "OKTA_CLIENT_ISSUER",
          "value" : "${var.okta_client_issuer}"
        },
        {
          "name" : "AZURE_CLIENT_ID",
          "value" : "${var.azure_client_id}"
        },
        {
          "name" : "AZURE_CLIENT_SECRET",
          "value" : "${var.azure_client_secret}"
        },

      ],
      mountPoints = [
        {
          containerPath = "/var/tmp/Roost",
          sourceVolume  = "efs-approost"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = aws_cloudwatch_log_group.roost.name
          awslogs-region        = "${data.aws_region.current.name}"
          awslogs-stream-prefix = "approost-container"
        }
      }
    },
    {
      name      = "roost-jump"
      image     = "${var.JUMPHOST_IMG}:${var.JUMPHOST_VER}"
      cpu       = tonumber(2048)
      memory    = tonumber(4096)
      essential = false
      portMappings = [
        {
          name          = "port-60001"
          containerPort = 60001
          hostPort      = 60001
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      environment = [
        {
          "name" : "VERBOSE_LEVEL",
          "value" : "4"
        },
        {
          "name" : "JUMPHOST",
          "value" : "true"
        },
        {
          "name" : "RUN_AS_CONTAINER",
          "value" : "true"
        },
        {
          "name" : "ENT_SERVER",
          "value" : "${var.enterprise_dns}"
        },
        {
          "name" : "ROOST_LOCAL_KEY",
          "value" : "${var.roost_local_key}"
        }
      ],
      mountPoints = [
        {
          containerPath = "/var/tmp/Roost",
          sourceVolume  = "efs-approost"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = aws_cloudwatch_log_group.roost.name
          awslogs-region        = "${data.aws_region.current.name}"
          awslogs-stream-prefix = "jumphost-container"
        }
      }
    },
  ])
  volume {
    name = "efs-approost"
    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.efs.id
      root_directory          = "/"
      transit_encryption_port = null
    }
  }
}



resource "aws_ecs_task_definition" "roosteaas" {
  family                   = "roost-eaas"
  execution_role_arn       = "${data.aws_iam_role.ecs_tasks_execution_role.arn}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 2048
  memory                   = 4096
  container_definitions = jsonencode([
    {
      name      = "roost-eaas"
      image     = "${var.RELEASE_IMG}:${var.RELEASE_VER}"
      cpu       = tonumber(2048)
      memory    = tonumber(4096)
      essential = true
      portMappings = [
        {
          name          = "port-60003"
          containerPort = 60003
          hostPort      = 60003
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
            environment = [
        {
          "name" : "VERBOSE_LEVEL",
          "value" : "${var.roost_verbose_level}"
        },
        {
          "name" : "RUN_AS_CONTAINER",
          "value" : "true"
        },
        {
          "name" : "ENT_SERVER",
          "value" : "${var.enterprise_dns}"
        },
        {
          "name" : "AUTH_KEY",
          "value" : "${var.roost_local_key}"
        }
      ],
      mountPoints = [
        {
          containerPath = "/var/tmp/Roost",
          sourceVolume  = "efs-releaseserver"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = aws_cloudwatch_log_group.roost.name
          awslogs-region        = "${data.aws_region.current.name}"
          awslogs-stream-prefix = "releaseserver-container"
        }
      }
    },
  ])
  volume {
    name = "efs-releaseserver"
    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.efs.id
      root_directory          = "/"
      transit_encryption_port = null
    }
  }
}

