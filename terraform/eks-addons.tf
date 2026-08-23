resource "aws_eks_addon" "cloud_platform_pod_identity_agent" {
  cluster_name = aws_eks_cluster.cloud_platform_eks_cluster.name
  addon_name   = "eks-pod-identity-agent"
}