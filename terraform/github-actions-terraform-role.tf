data "aws_iam_policy_document" "github_actions_terraform_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:krisk111@248812642/cloud-platform-infrastructure@1320697536:ref:refs/heads/main"
      ]
    }
  }
}

resource "aws_iam_role" "github_actions_terraform" {
  name               = "cloud-platform-github-actions-terraform"
  assume_role_policy = data.aws_iam_policy_document.github_actions_terraform_assume_role.json
}