output "backend_bucket_name" {
  description = "The name of the S3 bucket used for storing Terraform state files."
  value       = module.s3_backend.bucket_name
}

output "backend_bucket_id" {
  description = "The AWS ID (ARN) of the Terraform backend S3 bucket."
  value       = module.s3_backend.bucket_id
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table used for Terraform state locking."
  value       = module.dynamodb_backend.table_name
}

output "dynamodb_table_id" {
  description = "The AWS ID (ARN) of the DynamoDB lock table."
  value       = module.dynamodb_backend.table_id
}
