terraform {
  backend "s3" {
    region = "ap-south-1"
    bucket = "eaas-demo-terraform-states"
    key    = "roost-rds"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.63.0"
    }
  }
}
