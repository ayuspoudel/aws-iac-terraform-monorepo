provider "aws" {
  region = var.aws_region
}

# Ensure OIDC provider exists
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# Role for one repo
resource "aws_iam_role" "repo_role" {
  name = "github-oidc-${replace(var.repo_name, "/", "-")}"

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
            "token.actions.githubusercontent.com:sub" = "repo:${var.repo_name}:*"
          }
        }
      }
    ]
  })
}

# Attach all requested policies
resource "aws_iam_role_policy_attachment" "repo_attachments" {
  for_each = toset(var.policy_arns)
  role       = aws_iam_role.repo_role.name
  policy_arn = each.value
}

data "aws_caller_identity" "current" {}

output "repo_role_arn" {
  value = aws_iam_role.repo_role.arn
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}
