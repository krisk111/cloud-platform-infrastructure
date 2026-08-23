resource "aws_iam_policy" "cloud_platform_load_balancer_controller_policy" {
  name = "cloud-platform-load-balancer-controller-policy"

  policy = file("${path.module}/aws-load-balancer-controller-policy.json")
}

data "aws_iam_policy_document" "cloud_platform_load_balancer_controller_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cloud_platform_load_balancer_controller_role" {
  name               = "cloud-platform-load-balancer-controller-role"
  assume_role_policy = data.aws_iam_policy_document.cloud_platform_load_balancer_controller_assume_role.json
}

resource "aws_iam_role_policy_attachment" "cloud_platform_load_balancer_controller_policy_attachment" {
  role       = aws_iam_role.cloud_platform_load_balancer_controller_role.name
  policy_arn = aws_iam_policy.cloud_platform_load_balancer_controller_policy.arn
}

resource "aws_eks_pod_identity_association" "cloud_platform_load_balancer_controller" {
  cluster_name    = aws_eks_cluster.cloud_platform_eks_cluster.name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = aws_iam_role.cloud_platform_load_balancer_controller_role.arn
}