resource "aws_eks_addon" "cloud_platform_pod_identity_agent" {
  cluster_name = aws_eks_cluster.cloud_platform_eks_cluster.name
  addon_name   = "eks-pod-identity-agent"
}

resource "aws_iam_role" "cloud_platform_ebs_csi_role" {
  name = "cloud-platform-ebs-csi-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "pods.eks.amazonaws.com"
        }

        Action = [
          "sts:AssumeRole",
          "sts:TagSession",
        ]
      }
    ]
  })

  tags = {
    Project   = "cloud-platform"
    ManagedBy = "terraform"
  }
}

resource "aws_iam_role_policy_attachment" "cloud_platform_ebs_csi_policy" {
  role       = aws_iam_role.cloud_platform_ebs_csi_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEBSCSIDriverPolicyV2"
}

resource "aws_eks_pod_identity_association" "cloud_platform_ebs_csi" {
  cluster_name    = aws_eks_cluster.cloud_platform_eks_cluster.name
  namespace       = "kube-system"
  service_account = "ebs-csi-controller-sa"
  role_arn        = aws_iam_role.cloud_platform_ebs_csi_role.arn

  depends_on = [
    aws_eks_addon.cloud_platform_pod_identity_agent,
    aws_iam_role_policy_attachment.cloud_platform_ebs_csi_policy,
  ]
}

resource "aws_eks_addon" "cloud_platform_ebs_csi_driver" {
  cluster_name = aws_eks_cluster.cloud_platform_eks_cluster.name
  addon_name   = "aws-ebs-csi-driver"

  depends_on = [
    aws_eks_pod_identity_association.cloud_platform_ebs_csi,
  ]
}