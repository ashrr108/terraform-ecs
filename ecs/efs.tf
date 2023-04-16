resource "aws_efs_file_system" "efs" {
  creation_token = var.project_name
  tags = {
    Project = var.project_name
    Name = "roost-efs"
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
  tags = {
    Project = var.project_name
    Name = "roost-efs-sg"
  }
}

resource "aws_efs_mount_target" "mount_target" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.subnets[0]
  security_groups = [aws_security_group.efs_mount_target.id]
}