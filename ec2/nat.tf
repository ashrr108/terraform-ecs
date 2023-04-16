resource "aws_eip" "eaas_eip1" {
  vpc      = true
  tags = {
    Project = local.project
    Name = join("-",[var.prefix, var.company, "eip-1"])
  }
}
resource "aws_eip" "eaas_eip2" {
  vpc      = true
  tags = {
    Project = local.project
    Name = join("-",[var.prefix, var.company, "eip-2"])
  }
}
resource "aws_nat_gateway" "eaas_nat_gateway1" {
  allocation_id =   aws_eip.eaas_eip1.id
  subnet_id     =  aws_subnet.eaas_public_subnet1.id
  tags = {
    Project = local.project
    Name = join("-",[var.prefix, var.company, "nat-gateway-1"])
}
}
resource "aws_nat_gateway" "eaas_nat_gateway2" {
  allocation_id =   aws_eip.eaas_eip2.id
  subnet_id     =  aws_subnet.eaas_public_subnet2.id
  tags = {
    Project = local.project
    Name = join("-",[var.prefix, var.company, "nat-gateway-2"])
}
}