variable "AWS_ACCESS_KEY_ID" {
  type        = string
  description = "AWS_ACCESS_KEY_ID"
  sensitive   = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  type        = string
  description = "AWS_SECRET_ACCESS_KEY"
  sensitive   = true
}

variable "AWS_REGION" {
  type = string
}

variable "AWS_DEFAULT_TAGS" {
  type = map(any)
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}


# VPC

variable "vpc_cidr_block" {
  type = string
}
variable "public_subnets" {
    type = list(string)  
}
variable "private_subnets" {
    type = list(string)  
}


# EKS

variable "cluster_name_identifer" {
  type        = string
  description = "v4, v5 etc. which will generate cluster name PROEJCT_NAME-ENVIRONMENT-CLUSTER_NAME_IDENTIFER"
}

variable "eks_version" {
  type = string
}

variable "ami_type" {
  type = string
}

variable "instance_types" {
  type = list(string)
}

variable "instance_capacity_type" {
  type = string
}

variable "instance_storage_size" {
  type = number
}

variable "instance_storage_type" {
  type = string
}

variable "scaling_desired_size" {
  type = number
}
variable "scaling_max_size" {
  type = number
}
variable "scaling_min_size" {
  type = number
}

variable "iam_access_entries" {
  type = list(object({
    policy_arn    = string
    principal_arn = string
  }))
}

variable "eks_addons" {
  type = list(object({
    name    = string,
    version = string
  }))
}

variable "eks_upgrade_support_policy" {
  type = string
}

variable "node_group_max_unavailable" {
  type = number
}


# RDS
variable "rds_name" {
  description = "Name of the RDS."
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
}

