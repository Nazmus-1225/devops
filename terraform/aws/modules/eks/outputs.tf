output "eks_access_config" {
  value = aws_eks_cluster.eks_cluster.access_config
}

output "eks_cluster_arn" {
  value = aws_eks_cluster.eks_cluster.arn
}

output "eks_cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}
