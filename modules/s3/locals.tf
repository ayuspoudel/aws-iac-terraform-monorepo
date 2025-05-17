locals {
  raw_timestamp = timestamp()                            # e.g. 2025-05-17T12:34:56Z
  date_only     = substr(local.raw_timestamp, 0, 10)    # e.g. "2025-05-17"
  clean_date    = replace(local.date_only, "-", "")     # e.g. "20250517"
  s3_bucket_name = "${var.project}-${var.owner}-bucket-${locals.clean_date}"

  reserved_tags = {
    Owner        = var.owner
    Project      = var.project
    Terraform    = "true"
    Lifecycle    = var.resource_lifecycle
    CreatedDate  = timestamp()
    Managed_by   = "Terraform"
  }

  all_tags = merge(local.reserved_tags, var.tags)
}
