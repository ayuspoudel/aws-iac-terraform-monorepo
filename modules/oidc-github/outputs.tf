output "repo_role_arn" {
  description = "ARN of the IAM role that GitHub Actions can assume via OIDC"
  value       = aws_iam_role.repo_role.arn
}

output "repo_role_name" {
  description = "Name of the IAM role created for this repo"
  value       = aws_iam_role.repo_role.name
}

output "oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  value       = local.oidc_provider_arn
}

output "aws_account_id" {
  description = "AWS account ID where the role and provider are created"
  value       = data.aws_caller_identity.current.account_id
}
