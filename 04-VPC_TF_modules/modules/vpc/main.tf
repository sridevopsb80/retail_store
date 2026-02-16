## Resource-1: VPC
# https://developer.hashicorp.com/terraform/language/functions/merge
# merge function is used to combine two maps into one

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(var.tags, { Name = "${var.environment_name}-vpc" })
  lifecycle {
    prevent_destroy = false
  }
}

## Resource-2: Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags, { Name = "${var.environment_name}-igw" })
}

## Resource-3: Public Subnets

# az => local.public_subnets[index]
# Uses the local.azs name as the map key, and uses the corresponding local.public_subnet as the map value

resource "aws_subnet" "public" {
  for_each = { for index, az in local.azs : az => local.public_subnets[index] }
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = merge(var.tags, { Name = "${var.environment_name}-public-${each.key}" })
}

## Resource-4: Private Subnets
resource "aws_subnet" "private" {
  for_each = { for index, az in local.azs : az => local.public_subnets[index] }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key
  tags = merge(var.tags, { Name = "${var.environment_name}-private-${each.key}"})
}

## Resource-5: Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  tags = merge(var.tags, { Name = "${var.environment_name}-nat-eip" })
}

## Resource-6: NAT Gateway

# using allocation ID to associate the elastic IP with the NAT gateway
# https://developer.hashicorp.com/terraform/language/functions/values
# using values function to create just one NAT gateway in the first public subnet

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public)[0].id
  tags = merge(var.tags, { Name = "${var.environment_name}-nat" })
  depends_on = [aws_internet_gateway.igw]
}

## Resource-7: Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id # default gateway for all outbound traffic from public subnets to the internet
  }
  tags = merge(var.tags, { Name = "${var.environment_name}-public-rt" })
}

## Resource-8: Associate Public Route Table to all Public Subnets(3) using for_each loop
resource "aws_route_table_association" "public_rt_assoc" {
  for_each = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

## Resource-9: Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id # default gateway for all outbound traffic from private subnets to the internet 
  }
  tags = merge(var.tags, { Name = "${var.environment_name}-private-rt" })
}

## Resource-10: Associate Private Route Table to all Private Subnets (3) using for_each loop
resource "aws_route_table_association" "private_rt_assoc" {
  for_each = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}
