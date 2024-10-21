resource "aws_eks_addon" "addons" {
  for_each                    = { for addon in var.eks_addons : addon.name => addon }
  cluster_name                = aws_eks_cluster.eks_cluster.name
  addon_name                  = each.value.name
  addon_version               = each.value.version
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_eks_cluster.eks_cluster,
    aws_eks_node_group.eks-ng
  ]
}