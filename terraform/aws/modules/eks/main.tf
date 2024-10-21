resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.project_name}-${var.environment}-cluster-${var.cluster_name_identifer}"
  role_arn = aws_iam_role.cluster.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids              = flatten([var.public_subnet_ids[*], var.private_subnet_ids[*]])
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  upgrade_policy {
    support_type = var.eks_upgrade_support_policy
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-eks-${var.cluster_name_identifer}"
    },
  )

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
  ]
}

data "aws_ssm_parameter" "eks_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.eks_cluster.version}/amazon-linux-2/recommended/release_version"
}

resource "aws_eks_node_group" "eks-ng" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.project_name}-${var.environment}-ng"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = flatten([var.public_subnet_ids[*], var.private_subnet_ids[*]])

  # Update the release version for AMI
  release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_release_version.value)

  scaling_config {
    desired_size = var.scaling_desired_size
    max_size     = var.scaling_max_size
    min_size     = var.scaling_min_size
  }

  update_config {
    max_unavailable = var.node_group_max_unavailable
  }

  ami_type       = var.ami_type
  capacity_type  = var.instance_capacity_type
  instance_types = var.instance_types

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-eks-ng"
    }
  )

  depends_on = [
    aws_eks_cluster.eks_cluster,
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_launch_template" "launch_template" {
  name_prefix = "${var.project_name}-${var.environment}-eks-node-launch_template"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = var.instance_storage_size
      volume_type = var.instance_storage_type
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-eks-node-launch_template"
    }
  )
}
