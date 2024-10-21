resource "aws_eks_access_entry" "eks_access_entry" {
  for_each      = { for entry in var.iam_access_entries : entry.principal_arn => entry }
  cluster_name  = aws_eks_cluster.eks_cluster.name
  principal_arn = each.value.principal_arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "eks_policy_association" {
  for_each      = { for entry in var.iam_access_entries : entry.principal_arn => entry }
  cluster_name  = aws_eks_cluster.eks_cluster.name
  policy_arn    = each.value.policy_arn
  principal_arn = each.value.principal_arn

  access_scope {
    type = "cluster"
  }
}