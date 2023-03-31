resource "aws_lb" "eaas_load_balancer" {
  name               = "eaas-load-balancer"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.loadbalancer.id]
  subnets            = [aws_subnet.eaas_public_subnet1.id , aws_subnet.eaas_public_subnet2.id ]
  enable_deletion_protection = var.deletion_protection
  tags = {
    Project = local.project
    Name = join("-",[var.prefix, var.company, "loadbalancer"])
  }
}

resource "aws_lb_listener" "eaas-lb_listner" {
  load_balancer_arn = aws_lb.eaas_load_balancer.arn
  certificate_arn   = var.certificate_arn == "" ?  module.acm.acm_certificate_arn : var.certificate_arn
  port              = "443"
  protocol          = "HTTPS"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eaas_target_group.arn
  }
  tags = {
    Project = local.project
    Name = join("-",[var.prefix, var.company, "loadbalancer-listner"])
  }
}