
resource "aws_security_group" "loadbalancer" {
  name                   = "loadbalancer"
  description            = "Allow TLS inbound traffic for internet"
  vpc_id                 = data.aws_vpc.selected.id
  revoke_rules_on_delete = true

  ingress {
    description      = "HTTPS traffic from internet"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Project = var.project_name
    Name = "roost-alb-sg"
  }
}

resource "aws_security_group" "database" {
  name_prefix            = "database"
  description            = "Allow TLS inbound traffic"
  vpc_id                 = data.aws_vpc.selected.id
  revoke_rules_on_delete = true

  ingress {
    description     = "All loadbalancer from ECS Loadbalancer"
    from_port       = 3306
    to_port         = 3306
    protocol        = "0"
    security_groups = flatten([aws_security_group.roostnginx.*.id])
  }

  // Create ingress rule for within VPC
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Project = var.project_name
    Name = "roost-database-sg"
  }

  depends_on = [
    aws_security_group.roostnginx
  ]
}


resource "aws_security_group" "roostnginx" {
  name_prefix            = "roostnginx"
  description            = "Allow TLS inbound traffic for roost nginx"
  vpc_id                 = data.aws_vpc.selected.id
  revoke_rules_on_delete = true

  # TODO: Delete internet allowed ingress after testing
#   ingress {
#     description      = "Allow from internet"
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
  ingress {
    description     = "Allow from loadbalancer"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = flatten([aws_security_group.loadbalancer.*.id])
  }
  ingress {
    description = "for webroost"
    from_port   = 4200
    to_port     = 4200
    protocol    = "tcp"
    self        = true
  }
  ingress {
    description = "for approost"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    self        = true
  }
  ingress {
    description = "for jumphost"
    from_port   = 60001
    to_port     = 60001
    protocol    = "tcp"
    self        = true
  }
#   ingress {
#     description = "for consoleproxy"
#     from_port   = 3001
#     to_port     = 3001
#     protocol    = "tcp"
#     self        = true
#   }
  ingress {
    description = "for releaseserver"
    from_port   = 60003
    to_port     = 60003
    protocol    = "tcp"
    self        = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # lifecycle {
  #   create_before_destroy = true
  # }

  tags = {
    Project = var.project_name
    Name = "roost-sg"
  }

  depends_on = [
    aws_security_group.loadbalancer
  ]
}
