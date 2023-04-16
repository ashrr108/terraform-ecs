
provider aws{
  region = var.region
}
terraform {
  backend "s3" {
    region = "ap-south-1"
    bucket = "eaas-roost-terraform-states"
    key = "eaas-roost"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.44.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
  }
}
