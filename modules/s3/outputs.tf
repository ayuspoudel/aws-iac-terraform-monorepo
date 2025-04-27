output "bucket_name" {
  description = "The name of the S3 bucket created."
  value       = aws_s3_bucket.this.bucket
}

output "bucket_id" {
  description = "The ID/ARN of the S3 bucket created."
  value       = aws_s3_bucket.this.id
}
