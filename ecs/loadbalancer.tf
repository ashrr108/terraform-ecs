resource "aws_lb" "loadbalancer" {
  name               = "roost-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = flatten(["${aws_security_group.loadbalancer.*.id}"])
  subnets            = var.subnets
  enable_deletion_protection = false
  tags = {
    Project = var.project_name
    Name    = "roost-lb"
  }
}

resource "aws_lb_listener" "loadbalancer" {
  load_balancer_arn = aws_lb.loadbalancer.id
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.roostnginx.arn
  }
  tags = {
    Project = var.project_name
    Name    = "roost-lb-listener"
  }
}


# ======================= roostnginx =======================

resource "aws_lb_target_group" "roostnginx" {
  name        = "roostnginx-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.selected.id
  health_check {
    port                = 80
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 20
    interval            = 30
  }
  tags = {
    Project = var.project_name
    Name = "roost-lb-target-group"
  }
  depends_on = [
    aws_ecs_task_definition.roostnginx
  ]
}

resource "aws_lb_listener_rule" "roostnginx" {
  listener_arn = aws_lb_listener.loadbalancer.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.roostnginx.arn
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }
  tags = {
    Project = var.project_name
    Name = "roost-lb-listener-rule"
  }
}
