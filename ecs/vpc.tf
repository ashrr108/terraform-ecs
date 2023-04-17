data "aws_vpc" "selected" {
  id = var.vpc_id
  lifecycle {
    postcondition {
      condition     = self.enable_dns_support == true && self.enable_dns_hostnames  == true
      error_message = "DNS support should be enabled"
    }
  }
}

data "aws_region" "current" {
  id = var.region
}
