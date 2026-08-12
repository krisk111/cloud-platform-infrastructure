data "aws_caller_identity" "current" {}

resource "aws_iam_role_policy_attachment" "github_actions_terraform_read_only" {
  role       = aws_iam_role.github_actions_terraform.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

data "aws_iam_policy_document" "github_actions_terraform_state" {
  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::cloud-platform-terraform-state-${data.aws_caller_identity.current.account_id}"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::cloud-platform-terraform-state-${data.aws_caller_identity.current.account_id}/cloud-platform/terraform.tfstate"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::cloud-platform-terraform-state-${data.aws_caller_identity.current.account_id}/cloud-platform/terraform.tfstate.tflock"
    ]
  }
}

resource "aws_iam_policy" "github_actions_terraform_state" {
  name   = "cloud-platform-github-actions-terraform-state"
  policy = data.aws_iam_policy_document.github_actions_terraform_state.json
}

resource "aws_iam_role_policy_attachment" "github_actions_terraform_state" {
  role       = aws_iam_role.github_actions_terraform.name
  policy_arn = aws_iam_policy.github_actions_terraform_state.arn
}