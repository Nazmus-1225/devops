variable "AWS_DEFAULT_TAGS" {
  type = map(any)
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of CIDR blocks for the public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of CIDR blocks for the private subnets"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Whether to create a NAT Gateway"
  type        = bool
  default     = false
}

variable "enable_igw" {
  description = "Whether to create an Internet Gateway"
  type        = bool
  default     = false
}
