data "aws_route53_zone" "eaas" {
  zone_id = var.route53_hosted_zone_id
}

resource "aws_route53_record" "eaas" {
  zone_id = data.aws_route53_zone.eaas.zone_id
  name    = var.enterprise_dns
  type    = "A"
  alias {
      name                   = aws_lb.eaas_load_balancer.dns_name
      zone_id                = aws_lb.eaas_load_balancer.zone_id
      evaluate_target_health = true
  }
}