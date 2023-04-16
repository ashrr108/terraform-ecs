resource "aws_lb_target_group" "eaas_target_group" {
  name     = "eaas-target-group"
  target_type = "instance"
  port     = 443
  protocol = "HTTPS"
  protocol_version = "HTTP1"
  vpc_id   = aws_vpc.vpc.id
  health_check {
    port = 443
    path = "/api"
    protocol = "HTTPS"
    healthy_threshold = 2
  }
 tags = {
    Project = local.name
    Name = join("-",[var.prefix, var.company, "target-group"])
  }
}
resource "aws_lb_target_group_attachment" "controlplane_attachment" {
  target_group_arn = aws_lb_target_group.eaas_target_group.arn
  target_id        = aws_instance.roost_controlplane.id
  port             = 443
}