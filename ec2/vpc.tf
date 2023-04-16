resource "aws_vpc" "vpc" {
  cidr_block = join("/",[var.ip_block_vpc,"26"])
  tags={
    Project = local.project
    Name = join("-",[var.prefix, var.company, "vpc"])
  }
}
resource "aws_internet_gateway" "eaas_internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags={
    Project = local.project
    Name = join("-",[var.prefix, var.company, "igw"])
  }
}