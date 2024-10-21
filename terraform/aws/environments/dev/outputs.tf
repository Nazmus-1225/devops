output "vpc" {
    value = module.vpc
}

output "rds" {
    value = module.rds_postgresql
}

output "eks" {
    value = module.eks
}