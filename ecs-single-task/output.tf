output "cluster_arn" {
  value = var.create_cluster ? module.ecs[0].cluster_arn : data.aws_ecs_cluster.selected[0].arn
}

output "cluster_id" {
  value = var.create_cluster ? module.ecs[0].cluster_id : data.aws_ecs_cluster.selected[0].id
}

output "loadbalancer_dns" {
  value = aws_lb.loadbalancer.dns_name
}

output "subnet_ids" {
  value = join(",", [for s in var.subnets : format("%s", s)])
}
