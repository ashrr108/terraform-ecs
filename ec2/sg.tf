
resource "aws_security_group" "loadbalancer" {
  name        = "Roost LoadBalancer SG"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description      = "HTTPS connection from internet"
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
  tags = {
    Project = local.project
    Name = join("-",[var.prefix, var.company, "loadbalancer-sg"])
  }
}

resource "aws_security_group" "bastion" {
  name        = "Roost Bastion SG"
  description = "Allow SSH from anywhere to Bastion"
  vpc_id      = aws_vpc.vpc.id
  revoke_rules_on_delete = true
  ingress {
    description      = "Allow SSH from Internet"
    protocol         = "tcp"
    from_port        = 22
    to_port          = 22
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
  tags = {
    Project = local.project
    Name = join("-",[var.prefix, var.company, "bastion-sg"])
  }
}

resource "aws_default_security_group" "roost_vpc" {
  # name                   = "Roost VPC SG"
  # description = "Allow ALL traffic routing within VPC"
  vpc_id                 = aws_vpc.vpc.id
  revoke_rules_on_delete = true

  ingress {
    description      = "Allow all traffic from within current VPC"
    protocol         = -1
    self             = true
    from_port        = 0
    to_port          = 0
    ipv6_cidr_blocks = ["::/0"]
  }

#  ingress {
#    description     = "Allow SSH from SSH server only"
#    protocol        = "tcp"
#    from_port       = 22
#    to_port         = 22
#    security_groups = [aws_security_group.bastion.id]
#  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Project = local.project
    Name = join("-",[var.prefix, var.company, "vpc-sg"])
  }
}

resource "aws_security_group" "controlplane" {
  name        = "Roost Enterprise ControlPlane SG"
  description = "Security group for Roost controlplane"
  vpc_id      = aws_vpc.vpc.id
  revoke_rules_on_delete = true

  ingress {
    description      = "Allow SSH from Bastion"
    protocol         = "tcp"
    from_port        = 22
    to_port          = 22
    security_groups  = [aws_security_group.bastion.id]
  }

  ingress {
    description      = "Allow HTTPS from LoadBalancer"
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    security_groups  = [aws_security_group.loadbalancer.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Project = local.project
    Name = join("-",[var.prefix, var.company, "controlplane-sg"])
  }
}

resource "aws_security_group" "eaas_server" {
  name        = "Roost EaaS Server SG"
  description = "Security group for Roost EaaS server"
  vpc_id      = aws_vpc.vpc.id
  revoke_rules_on_delete = true

  ingress {
    description      = "SSH from Bastion"
    protocol         = "tcp"
    from_port        = 22
    to_port          = 22
    security_groups  = [aws_security_group.bastion.id]
  }
  ingress {
    description      = "SSH from Controlplane"
    protocol         = "tcp"
    from_port        = 22
    to_port          = 22
    security_groups = [aws_security_group.controlplane.id]
  }
  ingress {
    description      = "Custom TCP for Docker"
    from_port        = 5000
    to_port          = 5005
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "Custom TCP from Controlplane"
    from_port        = 60001
    to_port          = 62120
    protocol         = "tcp"
    security_groups = [aws_security_group.controlplane.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

 tags = {
    Project = local.project
    Name = join("-",[var.prefix, var.company, "eaas-sg"])
  }
}

# resource "aws_security_group" "sg_eaas_instances" {
#   name        = "sg_eaas_instances"
#   description = "Allow TLS inbound traffic"
#   vpc_id      = aws_vpc.vpc.id

#   ingress {
#     description      = "SSH port"
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     //security_groups = [aws_security_group.jumphost.id]
#   }
#   ingress {
#     description      = "https"
#     from_port        = 443
#     to_port          = 443
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     //security_groups = [aws_security_group.loadbalancer.id]
#   }
#   ingress {
#     description      = "Docker host"
#     from_port        = 5000
#     to_port          = 5000
#     protocol         = "tcp"
#     cidr_blocks      = [aws_vpc.vpc.cidr_block]
#     //security_groups = [aws_security_group.sg_eaas_instances.id]
#   }
#   ingress {
#     description      = "Docker Insecure Registry"
#     from_port        = 5002
#     to_port          = 5002
#     protocol         = "tcp"
#     cidr_blocks      = [aws_vpc.vpc.cidr_block]
#     //security_groups = [aws_security_group.sg_eaas_instances.id]
#   }
#     ingress {
#     description      = "Jumphost RoostAPIServer"
#     from_port        = 60001
#     to_port          = 60001
#     protocol         = "tcp"
#     cidr_blocks      = [aws_vpc.vpc.cidr_block]
#     //security_groups = [aws_security_group.sg_eaas_instances.id]
#     }
#   ingress {
#     description      = "RoostCluster Launch"
#     from_port        = 60002
#     to_port          = 60002
#     protocol         = "tcp"
#     cidr_blocks      = [aws_vpc.vpc.cidr_block]
#     //security_groups = [aws_security_group.sg_eaas_instances.id]
#   }
#   ingress {
#     description      = "EaaS API Server"
#     from_port        = 60003
#     to_port          = 60003
#     protocol         = "tcp"
#     cidr_blocks      = [aws_vpc.vpc.cidr_block]
#     //security_groups = [aws_security_group.sg_eaas_instances.id]
#   }
#   ingress {
#     description      = "Cypress Video Server"
#     from_port        = 60005
#     to_port          = 60005
#     protocol         = "tcp"
#     cidr_blocks      = [aws_vpc.vpc.cidr_block]
#     //security_groups = [aws_security_group.sg_eaas_instances.id]
#   }

#   ingress {
#       description      = "Web-console(gotty)"
#       from_port        = 60006
#       to_port          = 60006
#       protocol         = "tcp"
#       cidr_blocks      = [aws_vpc.vpc.cidr_block]
#       //security_groups = [aws_security_group.sg_eaas_instances.id]
#   }
#   ingress {
#       description      = "Dynamic gotty-ports"
#       from_port        = 62020
#       to_port          = 62120
#       protocol         = "tcp"
#       cidr_blocks      = [aws_vpc.vpc.cidr_block]
#       //security_groups = [aws_security_group.sg_eaas_instances.id]
#     }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     Project = local.project
#     Name = join("-",[var.prefix, var.company, "instances"])
#   }
# }

resource "aws_security_group" "jumphost" {
  name        = "Roost JumpHost Server SG"
  description = "Security group for Roost jumphost"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description      = "SSH from Bastion"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = [aws_security_group.bastion.id]
  }
  ingress {
    description      = "SSH from Controlplane"
    protocol         = "tcp"
    from_port        = 22
    to_port          = 22
    security_groups = [aws_security_group.controlplane.id]
  }
  ingress {
    description      = "Custom TCP for Docker"
    from_port        = 5000
    to_port          = 5005
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "Custom TCP from Controlplane"
    from_port        = 60001
    to_port          = 62120
    protocol         = "tcp"
    security_groups = [aws_security_group.controlplane.id]
  }
  ingress {
    description      = "Allow RoostApi access from EaaS Server"
    from_port        = 60001
    to_port          = 60001
    protocol         = "tcp"
    security_groups = [aws_security_group.eaas_server.id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Project = local.project
    Name = join("-",[var.prefix, var.company, "jumphost-sg"])
  }
}
