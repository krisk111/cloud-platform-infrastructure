resource "aws_eks_cluster" "cloud_platform_eks_cluster" {
  name     = "cloud-platform-eks-cluster"
  role_arn = aws_iam_role.cloud_platform_eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private_a.id,
      aws_subnet.private_b.id,
      aws_subnet.public_a.id,
      aws_subnet.public_b.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cloud_platform_eks_cluster_policy_attachment
  ]

  tags = {
    Project   = "cloud-platform"
    ManagedBy = "terraform"
  }
}