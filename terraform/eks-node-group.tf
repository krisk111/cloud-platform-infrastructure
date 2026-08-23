resource "aws_eks_node_group" "cloud_platform_eks_node_group" {
  cluster_name    = aws_eks_cluster.cloud_platform_eks_cluster.name
  node_group_name = "cloud-platform-eks-node-group"
  node_role_arn   = aws_iam_role.cloud_platform_eks_node_role.arn

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.cloud_platform_eks_worker_node_policy_attachment,
    aws_iam_role_policy_attachment.cloud_platform_eks_cni_policy_attachment,
    aws_iam_role_policy_attachment.cloud_platform_eks_ecr_read_only_attachment
  ]

  tags = {
    Project   = "cloud-platform"
    ManagedBy = "terraform"
  }
}