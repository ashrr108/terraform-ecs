resource "aws_route_table" "eaas_route_table1" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eaas_nat_gateway1.id
  }
  tags = {
    Project = local.project
    Name = join("-",[var.prefix, var.company, "nat-rtb-1"])

    }
}
resource "aws_route_table" "eaas_route_table2" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eaas_nat_gateway2.id
  }
  tags = {
    Project = local.project
    Name = join("-",[var.prefix, var.company, "na-rtb-2"])

    }
}
resource "aws_route_table" "eaas_route_table3" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eaas_internet_gateway.id
  }
  tags = {
    Project = local.project
    Name = join("-",[var.prefix, var.company, "igw-rtb"])

  }
}
resource "aws_route_table_association" "eaas_route_table_association1" {
  subnet_id      = aws_subnet.eaas_private_subnet1.id
  route_table_id = aws_route_table.eaas_route_table1.id
}
resource "aws_route_table_association" "eaas_route_table_association2" {
  subnet_id      = aws_subnet.eaas_private_subnet2.id
  route_table_id = aws_route_table.eaas_route_table2.id
}
resource "aws_route_table_association" "eaas_route_table_association3" {
  subnet_id      = aws_subnet.eaas_public_subnet2.id
  route_table_id = aws_route_table.eaas_route_table3.id
}
resource "aws_route_table_association" "eaas_route_table_association4" {
  subnet_id      = aws_subnet.eaas_public_subnet1.id
  route_table_id = aws_route_table.eaas_route_table3.id
}