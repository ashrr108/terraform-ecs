resource "aws_efs_file_system" "efs" {
  creation_token = var.project_name
  tags = {
    Project = var.project_name
    Name    = "roost-efs"
  }
}

resource "aws_security_group" "efs_mount_target" {
  name_prefix = "efs_mount_target"
  vpc_id      = data.aws_vpc.selected.id
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 2049
    to_port          = 2049
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Project = var.project_name
    Name    = "roost-efs-sg"
  }
}

resource "aws_efs_mount_target" "mount_target" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.private_subnet != "" ? var.private_subnet : var.subnets[0]
  security_groups = [aws_security_group.efs_mount_target.id]
}
