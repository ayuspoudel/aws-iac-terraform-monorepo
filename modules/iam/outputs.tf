output "iam_user_name" {
  description = "The name of the created IAM user"
  value       = aws_iam_user.this.name
}

output "iam_user_arn" {
  description = "The ARN of the created IAM user"
  value       = aws_iam_user.this.arn
}

output "iam_user_secret_arn" {
  description = "The ARN of the Secrets Manager secret storing IAM credentials"
  value       = aws_secretsmanager_secret.iam_user_secret.arn
}
