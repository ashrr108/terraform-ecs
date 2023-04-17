terraform {
  backend "s3" {
    region = "ap-south-1"
    bucket = "roost-ecs-single-task-harish"
    key    = "zbio-terraform-ecs"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.63.0"
    }
  }
}

provider "aws" {
  region = var.region
}
