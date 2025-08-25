provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}


# OIDC provider for GitHub Actions
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# IAM role for a single GitHub repository
resource "aws_iam_role" "repo_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringLike = {
            # allow workflows in this repo to assume the role
            "token.actions.githubusercontent.com:sub" = "repo:${var.repo}:*"
          }
        }
      }
    ]
  })
}

# Attach all requested IAM policies
resource "aws_iam_role_policy_attachment" "repo_attachments" {
  for_each = toset(var.policies)
  role       = aws_iam_role.repo_role.name
  policy_arn = each.value
}

# Current AWS account
data "aws_caller_identity" "current" {}
