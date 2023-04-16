resource "aws_subnet" "eaas_public_subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnets(local.cidr_block,2,2,2,2)[0]
  availability_zone       = local.az1
  map_public_ip_on_launch = true
  tags = {
    Project = local.project
    Name = join("-",[var.prefix, var.company, "public-subnet-1",local.az1])
  }
}
resource "aws_subnet" "eaas_public_subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnets(local.cidr_block,2,2,2,2)[1]
  availability_zone       = local.az2
  map_public_ip_on_launch = true
  tags = {
    Project = local.project
    Name = join("-",[var.prefix, var.company, "public-subnet-2",local.az2])
  }
}
resource "aws_subnet" "eaas_private_subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnets(local.cidr_block,2,2,2,2)[2]
  availability_zone       = local.az1
  map_public_ip_on_launch = false
  tags = {
    Project = local.project
    Name = join("-",[var.prefix, var.company, "private-subnet-1",local.az1])
  }
}
resource "aws_subnet" "eaas_private_subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnets(local.cidr_block,2,2,2,2)[3]
  availability_zone       = local.az2
  map_public_ip_on_launch = false
  tags = {
    Project = local.project
    Name = join("-",[var.prefix, var.company, "private-subnet-2",local.az2])
  }
}
# resource "aws_db_subnet_group" "eaas_subnet_group" {
#   count      = var.rds_setup ? 1 : 0
#   name       = "terraform-eaas"
#   subnet_ids = [aws_subnet.eaas_public_subnet1.id,aws_subnet.eaas_public_subnet2.id]
#   tags = {
#     Name = local.name
#     Project = local.project
#   }
# }