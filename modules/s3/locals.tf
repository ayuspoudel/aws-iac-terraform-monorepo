locals {
  s3_bucket_name = "${var.project}-${var.owner}-bucket"

  merged_tags = {
    Owner        = var.owner
    Project      = var.project
    Terraform    = "true"
    Lifecycle    = var.lifecycle
    CreatedDate  = timestamp()
  }
}


