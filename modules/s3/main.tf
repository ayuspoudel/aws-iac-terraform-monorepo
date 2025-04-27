resource "aws_s3_bucket" "this" {
  bucket        = local.s3_bucket_name
  force_destroy = var.force_destroy

  lifecycle {
    prevent_destroy = var.prevent_destroy
  }
  tags = local.merged_tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

