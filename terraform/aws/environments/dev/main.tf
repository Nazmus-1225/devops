module "vpc" {
  source         = "../../modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block
  azs            = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = true
  enable_igw         = true

  AWS_DEFAULT_TAGS = var.AWS_DEFAULT_TAGS
  environment      = var.environment
  project_name     = var.project_name
}


module "eks" {
  source                 = "../../modules/eks"
  tags                   = var.AWS_DEFAULT_TAGS
  cluster_name_identifer = var.cluster_name_identifer
  project_name           = var.project_name
  region                 = var.AWS_REGION
  environment            = var.environment
  vpc_id                 = module.vpc.vpc_id
  private_subnet_ids     = []
  public_subnet_ids      = module.vpc.public_subnet_ids
  eks_version            = var.eks_version
  ami_type               = var.ami_type
  instance_types         = var.instance_types
  instance_capacity_type = var.instance_capacity_type

  instance_storage_size = var.instance_storage_size
  instance_storage_type = var.instance_storage_type

  scaling_desired_size = var.scaling_desired_size
  scaling_max_size     = var.scaling_max_size
  scaling_min_size     = var.scaling_min_size

  iam_access_entries = var.iam_access_entries

  eks_addons = var.eks_addons

  eks_upgrade_support_policy = var.eks_upgrade_support_policy

  node_group_max_unavailable = var.node_group_max_unavailable
}


module "rds_postgresql" {
    source = "../../modules/rds_postgresql"

    project_name = var.project_name
    rds_name = var.rds_name

    aws_region = var.AWS_REGION
    AWS_DEFAULT_TAGS = var.AWS_DEFAULT_TAGS

    instance_class = var.instance_class
    engine_version = var.engine_version

    parameter_group_name = var.parameter_group_name
    
    db_password = var.db_password
    db_username = var.db_username

    vpc_id = module.vpc.vpc_id
    subnet_ids_for_subnet_groups = module.vpc.public_subnet_ids
    allowed_cidr_blocks = var.allowed_cidr_blocks

    allocated_storage = var.allocated_storage
    max_allocated_storage = var.max_allocated_storage

    publicly_accessible = var.publicly_accessible
}