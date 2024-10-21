variable "rds_name" {
  description = "Name of the RDS."
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the PostgreSQL instance"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the PostgreSQL instance"
  type        = list(string)
}

variable "allocated_storage" {
  description = "Allocated storage for the PostgreSQL instance (in GB)"
  type        = number
}

variable "max_allocated_storage" {
  description = "Allocated storage for the PostgreSQL instance (in GB)"
  type        = number
}


variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
}

variable "instance_class" {
  description = "Instance class for the PostgreSQL instance"
  type        = string
}

variable "db_username" {
  description = "Username for the PostgreSQL database"
  type        = string
}

variable "db_password" {
  description = "Password for the PostgreSQL database"
  type        = string
  sensitive   = true
}

variable "parameter_group_name" {
  description = "DB parameter group name"
  type        = string
}

variable "publicly_accessible" {
  description = "Should the PostgreSQL instance be publicly accessible"
  type        = bool
  default     = false
}

variable "subnet_ids_for_subnet_groups" {
  type = list(string)
  description = "Subnets for rds subnet group"
}

variable "AWS_DEFAULT_TAGS" {
  type = map(any)
}