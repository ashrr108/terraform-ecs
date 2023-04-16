module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "4.0.1"
  domain_name  = var.enterprise_dns
  zone_id      = data.aws_route53_zone.eaas.zone_id
  create_certificate = var.certificate_arn == "" ? true : false
  validation_method = "DNS"
  wait_for_validation = false
  create_route53_records = true
  validation_allow_overwrite_records = true
  tags = {
    Project = local.project
    Name = join("-",[var.prefix, var.company, "acm-cert"])
  }
}