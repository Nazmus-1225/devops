resource "random_string" "my_random_string" {
  length  = 16      # Length of the string
  special = false   # Include special characters
  upper   = true    # Include uppercase characters
  lower   = true    # Include lowercase characters
  numeric = true    # Include numbers
}


locals {
  db_subnet_group_name = "${var.rds_name}_subnet_group"
}

# Security Group to allow access to the PostgreSQL instance
resource "aws_security_group" "rds_sg" {
  name        = "${var.rds_name}_rds_sg"
  description = "Allow PostgreSQL traffic from vpc and other allowed source"
  vpc_id      = var.vpc_id

  tags = merge(
    var.AWS_DEFAULT_TAGS,
    {
      Name = "${var.rds_name}_rds_sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "allow_pg" {
  for_each          = toset(var.allowed_cidr_blocks)
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = each.value
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


# Subnet Group
# Get details for each subnet
data "aws_subnet" "selected_subnets" {
  count = length(var.subnet_ids_for_subnet_groups)
  id    = var.subnet_ids_for_subnet_groups[count.index]
}

# Filter subnets by unique availability zones
locals {
  subnets_by_az = distinct([
    for subnet in data.aws_subnet.selected_subnets : {
      id  = subnet.id
      az  = subnet.availability_zone
    }
  ])

  # Extract only the subnet IDs (as a list of strings)
  subnet_ids = [for s in local.subnets_by_az : s.id]
}


resource "aws_db_subnet_group" "pg_subnet_group" {
  name       = "${var.rds_name}_rds_subnet_group"
  subnet_ids = slice(local.subnet_ids, 0, 3)

  tags = merge(
    var.AWS_DEFAULT_TAGS,
    {
      Name = "${var.rds_name}_rds_subnet_group"
    }
  )
}


# PostgreSQL Instance
resource "aws_db_instance" "postgres_single_instance" {
  identifier = var.rds_name
  engine                 = "postgres"
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = var.parameter_group_name
  publicly_accessible    = var.publicly_accessible
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.pg_subnet_group.name

  storage_type = "gp3"
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  final_snapshot_identifier = random_string.my_random_string.result

  tags = merge(
    var.AWS_DEFAULT_TAGS,
    {
      Name = var.rds_name
    }
  )
}
