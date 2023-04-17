module "ecs" {
  count        = var.create_cluster ? 1 : 0
  source       = "terraform-aws-modules/ecs/aws"
  version      = "4.1.2"
  cluster_name = var.cluster_name

  tags = {
    Project = var.project_name
    Name = "roost-ecs"
  }
}


data "aws_ecs_cluster" "selected" {
  count        = var.create_cluster ? 0 : 1
  cluster_name = var.cluster_name
}
