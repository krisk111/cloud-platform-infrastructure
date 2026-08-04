data "aws_iam_policy_document" "github_actions_ecr_permissions" {
  statement {
    sid    = "GetEcrAuthorizationToken"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "PushApplicationImages"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]

    resources = [
      aws_ecr_repository.application_container_repository.arn
    ]
  }
}

resource "aws_iam_policy" "github_actions_ecr_publish_permissions" {
  name        = "cloud-platform-github-actions-ecr-publisher"
  description = "Allows GitHub Actions to publish application images to ECR"

  policy = data.aws_iam_policy_document.github_actions_ecr_permissions.json

  tags = {
    Project   = "cloud-platform"
    ManagedBy = "terraform"
  }
}

resource "aws_iam_role_policy_attachment" "github_actions_ecr_publish_permissions" {
  role       = aws_iam_role.github_actions_ecr_publisher.name
  policy_arn = aws_iam_policy.github_actions_ecr_publish_permissions.arn
}