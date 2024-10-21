resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support   = true  # Enable DNS resolution
  enable_dns_hostnames = true  # Enable DNS hostnames
  tags = merge(
    var.AWS_DEFAULT_TAGS,
    {
      Name = "VPC-${var.environment}-${var.project_name}"
    }
  )
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  count  = var.enable_igw ? 1 : 0
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat[0].id
  subnet_id     = element(aws_subnet.public.*.id, 0)
  count         = var.enable_nat_gateway ? 1 : 0
}

resource "aws_eip" "nat" {
  domain   = "vpc"
  count = var.enable_nat_gateway ? 1 : 0
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.azs, count.index % length(var.azs))
  map_public_ip_on_launch = true

  tags = merge(
    var.AWS_DEFAULT_TAGS,
    {
      Name = "Public Subnet - ${var.environment} - ${var.project_name} - ${count.index + 1}"
      "kubernetes.io/role/elb" = 1
    }
  )
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.azs, count.index % length(var.azs))

  tags = merge(
    var.AWS_DEFAULT_TAGS,
    {
      Name = "Private Subnet - ${var.environment} - ${var.project_name} - ${count.index + 1}"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }
  
  tags = merge(
    var.AWS_DEFAULT_TAGS,
    {
      Name = "Public Route Table - ${var.environment} - ${var.project_name}"
    }
  )
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[0].id
  }

  tags = merge(
    var.AWS_DEFAULT_TAGS,
    {
      Name = "Private Route Table - ${var.environment} - ${var.project_name}"
    }
  )
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
