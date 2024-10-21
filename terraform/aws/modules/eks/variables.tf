variable "tags" {
  type = map(any)
}

variable "cluster_name_identifer" {
  type        = string
  description = "v4, v5 etc. which will generate cluster name PROEJCT_NAME-ENVIRONMENT-CLUSTER_NAME_IDENTIFER"
}

variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
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