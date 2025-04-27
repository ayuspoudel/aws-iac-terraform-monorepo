output "iam_user_name" {
  description = "The name of the created IAM user"
  value       = var.create_iam_user ? aws_iam_user.this[0].name : null
}

output "iam_user_arn" {
  description = "The ARN of the created IAM user"
  value       = var.create_iam_user ? aws_iam_user.this[0].arn : null
}

output "iam_user_secret_arn" {
  description = "The ARN of the Secrets Manager secret storing IAM credentials"
  value       = var.create_iam_user ? aws_secretsmanager_secret.iam_user_secret[0].arn : null
}

output "iam_role_arn" {
  description = "The ARN of the IAM Role."
  value       = aws_iam_role.this.arn
}
